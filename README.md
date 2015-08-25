# Serialism

Kinda like (and inspired by) [ActiveModel::Serializer](https://github.com/rails-api/active_model_serializers),
but with a smaller/simpler feature set and not JSON-centric.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'serialism'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install serialism

## Usage

```ruby
# A class you want to serialize instances of.
class Foo
  attr_accessor :id

  def initialize(id)
    @id = id
  end
end

# A class describing how you want to serialize instances of Foo.
class FooSerializer < Serialism::Serializer

  # These properties will be present in each serialized record.
  attributes :id, :computed

  # Methods have access to the `Foo` instance they're working on via `object`.
  def computed
    "computed - #{object.id}"
  end
end

items = [
  Foo.new(1),
  Foo.new(2),
  Foo.new(3)
]

serializer = FooSerializer.new(items[0])
serializer.render
# => {:id=>1, :computed=>"computed - 1"}

collection = Serialism::Collection.new(items, serializer: FooSerializer)

puts collection.to_csv
# id,computed
# 1,computed - 1
# 2,computed - 2
# 3,computed - 3

puts collection.to_json
# [
#   {
#     "id": 1,
#     "computed": "computed - 1"
#   },
#   {
#     "id": 2,
#     "computed": "computed - 2"
#   },
#   {
#     "id": 3,
#     "computed": "computed - 3"
#   }
# ]


```
