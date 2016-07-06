require 'spec_helper'

RSpec.describe Serialism::Collection, type: :model do

  # a serializer class
  let(:serializer) do
    Class.new(Serialism::Serializer) do
      attributes :id, :computed

      def computed
        "computed - #{object.id}"
      end
    end
  end

  # a class being serialized
  let(:serialized) do
    Struct.new(:id)
  end

  let(:items) do
    3.times.map do |i|
      serialized.new(i)
    end
  end

  let(:collection) do
    Serialism::Collection.new(items, serializer: serializer)
  end

  describe 'initialize' do
    it 'should require serializer to implement class-level attributes' do
      invalid_serializer = Class.new

      expect {
        Serialism::Collection.new([], serializer: invalid_serializer)
      }.to(
        raise_error(
          ArgumentError,
          'serializer must implement a class-level :attributes method'
        )
      )
    end

    it 'should require serializer to implement instance-level render' do
      invalid_serializer = Class.new do
        def self.attributes
        end
      end

      expect {
        Serialism::Collection.new([], serializer: invalid_serializer)
      }.to raise_error(ArgumentError, 'serializer must implement an instance-level :render method')
    end

    it 'should succeed when given a valid serializer' do
      serializer = Class.new do
        def self.attributes
        end

        def render
        end
      end

      expect {
        Serialism::Collection.new([], serializer: serializer)
      }.not_to raise_error
    end
  end

  describe 'items=' do
    it 'should require argument to respond_to :each' do
      expect {
        collection.items = :blat
      }.to raise_error(ArgumentError, 'argument must respond_to :each')
    end
  end

  describe 'attributes' do
    it 'should return array of attributes' do
      expect(collection.attributes).to eq serializer.attributes
    end

    it 'should return empty array if no items exist' do
      expect(
        Serialism::Collection.new([], serializer: serializer).attributes
      ).to eq []
    end
  end

  describe 'to_csv' do
    it 'should generate a csv string' do

      expected = <<-EOF
id,computed
0,computed - 0
1,computed - 1
2,computed - 2
EOF
      expect(collection.to_csv).to eq expected
    end

    it 'should encode complex cells as csv strings' do
      collection.items = [
        serialized.new([1, 2, 3]),
        serialized.new([4, 5, 6])
      ]

      expected = <<-EOF
id,computed
"1,2,3","computed - [1, 2, 3]"
"4,5,6","computed - [4, 5, 6]"
EOF
      expect(collection.to_csv).to eq expected
    end
  end

  describe 'to_json' do
    it 'should generate json' do
      expect(collection.to_json).to eq(
        '[' \
          '{"id":0,"computed":"computed - 0"},' \
          '{"id":1,"computed":"computed - 1"},' \
          '{"id":2,"computed":"computed - 2"}' \
        ']'
      )
    end
  end

end
