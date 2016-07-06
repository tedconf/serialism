require 'spec_helper'

RSpec.describe Serialism::Serializer, type: :model do

  let(:subject) do
    Class.new(Serialism::Serializer) do
      attributes :id, :computed

      def computed
        "computed by serializer - #{object.id}"
      end
    end
  end

  describe '.attributes' do
    it 'should allow attributes to be set and retrieved' do
      subject.attributes(:a, :b)

      expect(subject.attributes).to eq([:a, :b])
    end
  end

  describe '#render' do
    let(:item) do
      item_class = Struct.new(:id, :computed)
      item_class.new(1, "'computed' defined in item")
    end

    it 'should prefer attribute implementations in the serializer' do
      values = subject.new(item).render
      expect(values[:computed]).to eq 'computed by serializer - 1'
    end

    it 'should use attribute implementation in object if not defined explicitly in serializer' do
      values = subject.new(item).render
      expect(values[:id]).to eq 1
    end
  end

end
