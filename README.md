# ActsAsHavingStringId
A Rails plugin for exposing non-sequential (Youtube-like) string IDs instead of the sequential integer IDs provided by Rails.

Before, your API may look like

    GET /users/123
    {
      "id": 123,
      "name": "Alice O'User"
    }

After

    GET /users/9w63Hubh4oL
    {
      "id": "9w63Hubh4oL",
      "name": "Alice O'User"
    }

## Problem
Exposing sequential integer IDs has several drawbacks:

* Javascript has a 53-bit limit for integers (see https://dev.twitter.com/overview/api/twitter-ids-json-and-snowflake), which is a problem if you have large IDs
* Perhaps you don't want objects to be easily enumerable, even if they're public (if you know about http://example.com/documents/104, it's way too easy to find document 105)
* Sequential IDs make it easy to know how much usage your product gets (if my newly created user is http://example.com/users/1337, your product probably has 1,337 users)

## Why not use UUIDs?
"But why not just use UUIDs", you ask? Rails has built-in support for them. But they are very long. Exposing them in an API is okay, but in a URL just doesn't look nice

    http://example.com/objects/be398f64-320f-4731-be73-74699e6795bc
    
Even base62 encoding that ID is very long

    http://example.com/objects/27WzQMxpvINgio2w5Xt0hk
    
64-bit integers would be optimal, but they can't be random: the risk of collisions would be too high.

## Our solution
Rails makes heavy use of sequential integer IDs internally, but there's no need of exposing them. `ActsAsHavingStringId` provides an alternative string representation of your IDs. This representation is

    base62(tea(id, md5(ModelClass.name + Rails.application.secrets.string_id_key)))

The representation looks something like "E0znqip4mRA".

`tea` above is the "New variant" of the [Tiny Encryption Algorithm](https://en.wikipedia.org/wiki/Tiny_Encryption_Algorithm). You should probably not consider your id to be forever secret, but it should be pretty hard to figure out from the string representation.

Your controllers will continue to work without modification, but will start to accept string IDs. So if http://example.com/orders/104 worked before, something like http://example.com/orders/E0znqip4mRA should magically work.

## Usage
First, set up your `secrets.yml`:

    development:
      string_id_key: notverysecret

    test:
      string_id_key: notverysecreteither

    production:
      string_id_key: <%= ENV["STRING_ID_KEY"] %>

Then, call the method in your model class, after any relations to other models:

    class MyModel < ApplicationRecord
       has_many :my_other_model
       acts_as_having_string_id
    end

The id of your model will now not be an int, but rather an instance of `ActsAsHavingStringId::StringId`. As an example:

    > m = MyModel.create!
    > m.id
    => 1/7EajpSfdWIf
    > m.id.to_i
    => 1
    > m.id.to_s
    => "7EajpSfdWIf"

All ActiveRecord functions will continue to accept int IDs, but will now also accept the string representation as input:

    > MyModel.find("7EajpSfdWIf")
    => #<MyModel id: 1/7EajpSfdWIf, created_at: "2016-08-31 13:27:02", updated_at: "2016-08-31 13:27:02">
    > MyModel.where(id: "7EajpSfdWIf")
    => #<ActiveRecord::Relation [#<MyModel id: 1/7EajpSfdWIf, created_at: "2016-08-31 13:27:02", updated_at: "2016-08-31 13:27:02">]>
    
In all associated models, foreign keys to your model will also be this new type of id.

    > MyOtherModel.create! my_model: MyModel.first
    => #<MyOtherModel id: 1, my_model_id: 1/GBpjdLndSR0, created_at: "2016-09-07 10:32:24", updated_at: "2016-09-07 10:32:24"> 

Then, for exposing your string ID, make sure to always use `id.to_s`. For example, if you're using [ActiveModelSerializers](https://github.com/rails-api/active_model_serializers):

    class UserSerializer < ActiveModel::Serializer
      attributes :id, :name

      def id
        object.id.to_s
      end
    end

You can get the string representation of an ID from a class without having the instance

    > MyModel.id_string(1)
    => "7EajpSfdWIf"

And, conversely, getting the ID from the string representation

    > MyModel.id_int("7EajpSfdWIf")
    => 1

And that's just about it!

## TODO
* Since the `MyModel.find("7EajpSfdWIf")` functionality depends on the argument now being a string, `MyModel.find("5")` will no longer mean `MyModel.find(5)`, but rather `MyModel.find(4387534)` or something. Is that a problem?
* It's a potential security problem that we don't force strings from controllers (integer id coming from JSON postdata will make it find by original id)

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'acts_as_having_string_id'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install acts_as_having_string_id
```

## Contributing
To contribute, fork and clone the repo, edit the code (don't change the version number of the gem). Add tests, run them using

    bin/test

Then create a pull request.

To build the gem (this is mostly for myself), run

    gem build acts_as_having_string_id.gemspec

## Acknowledgements
The Tiny Encryption Algorithm was created by David Wheeler and Roger Needham of the Cambridge Computer Laboratory. This library's implementation is based on [this code](https://github.com/pmarreck/ruby-snippets/blob/master/TEA.rb) by Jeremy Hinegardner.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
