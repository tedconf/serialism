module Serialism
  # Base class for concrete serializers to inherit from.
  #
  # Example:
  #
  #   class Foo
  #     attr_accessor :id
  #   end
  #
  #   class FooSerializer < Serialism::Serializer
  #     attributes :id, :computed
  #
  #     def computed
  #       "computed - #{object.id}"
  #     end
  #   end
  #
  #   item = Foo.new
  #   item.id = 12
  #
  #   serializer = FooSerializer.new(item)
  #   serializer.render
  #   # => {id: 12, computed: "computed - 12"}
  class Serializer
    attr_reader :object

    @attributes = []
    def self.attributes(*attrs)
      @attributes = attrs if !attrs.empty?
      @attributes
    end

    def initialize(object)
      @object = object
    end

    # Transform `object` using rules defined by the serializer.
    #
    # @return [Hash] Keys are defined by the classes `attributes`.
    def render
      self.class.attributes.inject({}) do |memo, attr|
        if respond_to?(attr)
          memo[attr] = send(attr)
        elsif object.respond_to?(attr)
          memo[attr] = object.send(attr)
        else
          raise ArgumentError, "Unknown attribute :#{attr}"
        end
        memo
      end
    end
  end
end
