# ActsAsHavingStringId
A Rails plugin for exposing non-sequential (Youtube-like) string IDs instead of the sequential integer IDs provided by Rails.

Exposing sequential integer IDs has several drawbacks:

* Javascript has a 53-bit limit for integers (see https://dev.twitter.com/overview/api/twitter-ids-json-and-snowflake), which is a problem if you have large ids
* Perhaps you don't want objects to be easily enumerable, even if they're public (if you know about http://example.com/documents/104, it's way to easy to find document 105)
* Sequential IDs make it easy to know how much usage your product gets (if my newly created user is http://example.com/users/1337, your product probably has 1,337 users)

Rails makes heavy use of sequential integer IDs internally, but there's no need of exposing them. `ActsAsHavingStringId` provides an alternative string representation of your IDs. This representation is

    base62(tea(id, md5(ModelClass.name + Rails.application.secrets.tea_key)))

The representation looks something like "E0znqip4mRA".

`tea` above is the "New variant" of the (Tiny Encryption Algorithm)[https://en.wikipedia.org/wiki/Tiny_Encryption_Algorithm]. You should probably not consider your id to be forever secret, but it should be pretty hard to figure out from the string representation.

Your controllers will continue to work without modification, but will suddenly start to accept the string ids. So if http://example.com/orders/104 worked before, something like http://example.com/orders/E0znqip4mRA should magically work.

You do however need to take care never to expose the `id` member of your models. Instead, use `id_string`.

## Usage
First, set up your `secrets.yml`:

    development:
      tea_key: notverysecret

    test:
      tea_key: notverysecreteither

    production:
      tea_key: <%= ENV["TEA_KEY"] %>

Then, include the module in your `ApplicationRecord`:

    class ApplicationRecord < ActiveRecord::Base
      include ActsAsHavingStringId

      self.abstract_class = true
    end

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

## TODO
* Publish on rubygems
* Rename `tea_key` secret to `string_id_key`
* How to get rid of the include?
* Since the `MyModel.find("7EajpSfdWIf")` functionality depends on the argument now being a string, `MyModel.find("5")` will no longer mean `MyModel.find(5)`, but rather MyModel.find(4387534) or something. Is that a problem?

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
The Tiny Encryption Algorithm was created by David Wheeler and Roger Needham of the Cambridge Computer Laboratory. This library's implementation is based on (this code)[https://github.com/pmarreck/ruby-snippets/blob/master/TEA.rb] by Jeremy Hinegardner.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
