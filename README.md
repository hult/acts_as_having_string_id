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

Exposing sequential integer IDs has several drawbacks:

* Javascript has a 53-bit limit for integers (see https://dev.twitter.com/overview/api/twitter-ids-json-and-snowflake), which is a problem if you have large IDs
* Perhaps you don't want objects to be easily enumerable, even if they're public (if you know about http://example.com/documents/104, it's way too easy to find document 105)
* Sequential IDs make it easy to know how much usage your product gets (if my newly created user is http://example.com/users/1337, your product probably has 1,337 users)

Rails makes heavy use of sequential integer IDs internally, but there's no need of exposing them. `ActsAsHavingStringId` provides an alternative string representation of your IDs. This representation is

    base62(tea(id, md5(ModelClass.name + Rails.application.secrets.string_id_key)))

The representation looks something like "E0znqip4mRA".

`tea` above is the "New variant" of the [Tiny Encryption Algorithm](https://en.wikipedia.org/wiki/Tiny_Encryption_Algorithm). You should probably not consider your id to be forever secret, but it should be pretty hard to figure out from the string representation.

Your controllers will continue to work without modification, but will start to accept string IDs. So if http://example.com/orders/104 worked before, something like http://example.com/orders/E0znqip4mRA should magically work.

You do however need to take care never to expose the `id` member of your models. Instead, use `id_string`.

## Usage
First, set up your `secrets.yml`:

    development:
      string_id_key: notverysecret

    test:
      string_id_key: notverysecreteither

    production:
      string_id_key: <%= ENV["STRING_ID_KEY"] %>

Then, call the method in your model class:

    class MyModel < ApplicationRecord
       acts_as_having_string_id
    end

The string representation is now available as `id_string` on your model object. As an example:

    > m = MyModel.create!
    > m.id
    => 1
    > m.id_string
    => "7EajpSfdWIf"

All ActiveRecord functions will also accept the string representation as input:

    > MyModel.find("7EajpSfdWIf")
    => #<MyModel id: 1, created_at: "2016-08-31 13:27:02", updated_at: "2016-08-31 13:27:02">
    > MyModel.where(id: "7EajpSfdWIf")
    => #<ActiveRecord::Relation [#<MyModel id: 1, created_at: "2016-08-31 13:27:02", updated_at: "2016-08-31 13:27:02">]>

Then, for exposing your string ID, use the `id_string` method. For example, if you're using [ActiveModelSerializers](https://github.com/rails-api/active_model_serializers):

    class UserSerializer < ActiveModel::Serializer
      attributes :id, :name

      def id
        object.id_string
      end
    end

And that's just about it!

## TODO
* The integer representation of a string ID should be accessible using something like `MyModel.id_int(s)`
* You should be able to do `MyOtherModel.create! my_model_id: "KuUnDvpJYS2"` and `my_other_model.my_model_id = "KuUnDvpJYS2"`
* Since the `MyModel.find("7EajpSfdWIf")` functionality depends on the argument now being a string, `MyModel.find("5")` will no longer mean `MyModel.find(5)`, but rather `MyModel.find(4387534)` or something. Is that a problem?
* It's a potential security problem that we don't force strings from controllers (integer id coming from JSON postdata will make it find by original id)
* Although TEA handles (and outputs) 64-bit ids, we currently limit the input to 32-bit

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
To contribute, fork the repo, edit the code and create a pull request with tests. :)

## Acknowledgements
The Tiny Encryption Algorithm was created by David Wheeler and Roger Needham of the Cambridge Computer Laboratory. This library's implementation is based on [this code](https://github.com/pmarreck/ruby-snippets/blob/master/TEA.rb) by Jeremy Hinegardner.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
