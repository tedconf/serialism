module Serialism

  # Combines a set of items and a serializer class.
  #
  # Example:
  #
  #   class Foo
  #     attr_accessor :id
  #   end
  #
  #   class FooSerializer < Serialism::Serializer
  #     attributes :id
  #   end
  #
  #   Serialism::Collection.new(a_bunch_of_foo_instances, serializer: FooSerializer).to_csv
  #   #=> returns a CSV string
  class Collection

    attr_reader :items

    # create a new collection
    #
    # @param [Enumerable] items
    #    A collection of items.
    #    All member items should be encodable by `serializer`.
    # @param [Serialism::Serializer] serializer
    #    The serializer class used to encode members of `items`.
    def initialize(items=[], serializer:)
      if ! serializer.respond_to?(:attributes)
        raise ArgumentError, "serializer must implement a class-level :attributes method"
      end
      if ! serializer.instance_methods.include?(:render)
        raise ArgumentError, "serializer must implement an instance-level :render method"
      end
      @serializer = serializer

      self.items = items
    end

    # Set the items in the collection.
    #
    # Replaces any previous items already in the collection.
    #
    # @param [#each] items an enumerable collection of items
    # @return [Serialism::Collection]
    def items=(items)
      raise ArgumentError, "argument must respond_to :each" if ! items.respond_to?(:each)
      raise ArgumentError, "argument must respond_to :map" if ! items.respond_to?(:map)

      @items = items
      self
    end

    # return the attributes for the collection
    #
    # @return [Array]
    def attributes
      return [] if items.size == 0

      @serializer.attributes
    end

    # Generate a csv string for the collection
    #
    # When members of the array returned by the serializer are themselves arrays,
    # these sub-arrays will be joined using "," prior to being added to the main
    # CSV.
    #
    # @return [String]
    def to_csv
      require 'csv'

      CSV.generate do |csv|
        csv << attributes
        items.each do |t|

          row = @serializer.new(t).render.values.map do |cell|
            # convert complex cells to comma-separated strings
            cell.is_a?(Array) ? cell.join(',') : cell
          end

          csv << row
        end
      end
    end

    def to_json
      require 'json'

      JSON.dump(items.map {|t| @serializer.new(t).render })
    end

  end
end
