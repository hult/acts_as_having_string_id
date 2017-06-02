require 'test_helper'
require 'acts_as_having_string_id'

class AuthorWithStringId < ApplicationRecord
  self.table_name = 'authors'
  acts_as_having_string_id
end

class ActsAsHavingStringId::Test < ActiveSupport::TestCase
  test "your id a StringId" do
    author = AuthorWithStringId.create!
    assert author.id.is_a?(ActsAsHavingStringId::StringId)
  end

  test "adds id_string and id_int class methods" do
    assert_equal "ssRuI3aTLF", AuthorWithStringId.id_string(1)
    assert_equal 1, AuthorWithStringId.id_int("ssRuI3aTLF")
  end

  test "find supports int, string and StringId" do
    author = AuthorWithStringId.create!

    author_by_string = AuthorWithStringId.find(author.id.to_s)
    assert_equal author, author_by_string

    author_by_int = AuthorWithStringId.find(author.id.to_i)
    assert_equal author, author_by_int

    author_by_string_id = AuthorWithStringId.find(author.id)
    assert_equal author, author_by_string_id
  end

  test "where statements support string, int and StringId" do
    author = AuthorWithStringId.create!

    author_by_string = AuthorWithStringId.where(id: author.id.to_s).first
    assert_equal author, author_by_string

    author_by_int = AuthorWithStringId.where(id: author.id.to_i).first
    assert_equal author, author_by_int

    author_by_string_id = AuthorWithStringId.where(id: author.id).first
    assert_equal author, author_by_string_id
  end

  test "supports assigning foreign keys both as int, string and StringId" do
    class Author3 < ApplicationRecord
      self.table_name = 'authors'
      acts_as_having_string_id
    end

    class Book3 < ApplicationRecord
      self.table_name = 'books'
      belongs_to :author, class_name: 'Author3'
      acts_as_having_string_id
    end

    author_id = ActsAsHavingStringId::StringId.new(Author3, 5)

    book = Book3.new author_id: author_id.to_s
    assert_equal author_id, book.author_id

    book = Book3.new author_id: author_id.to_i
    assert_equal author_id, book.author_id

    book = Book3.new author_id: author_id
    assert_equal author_id, book.author_id
  end

  test "finding by an invalid string id means not found" do
    assert_raises ActiveRecord::RecordNotFound do
      AuthorWithStringId.find("alice@example.com")
    end
  end

  test "has_many/belongs_to relationship, both string id" do
    class Book1 < ApplicationRecord
      self.table_name = 'books'
    end

    class Author1 < ApplicationRecord
      self.table_name = 'authors'
      has_many :books, class_name: 'Book1'
      acts_as_having_string_id
    end

    class Book1 < ApplicationRecord
      belongs_to :author, class_name: 'Author1'
      acts_as_having_string_id
    end

    author = Author1.create!
    book = Book1.create! author: author

    assert author.id.is_a? ActsAsHavingStringId::StringId
    assert book.id.is_a? ActsAsHavingStringId::StringId
    assert book.author_id.is_a? ActsAsHavingStringId::StringId
  end

  test "has_many/belongs_to relationship, only belonger string id" do
    class Book2 < ApplicationRecord
      self.table_name = 'books'
    end

    class Author2 < ApplicationRecord
      self.table_name = 'authors'
      has_many :books, class_name: 'Book2'
    end

    class Book2 < ApplicationRecord
      belongs_to :author, class_name: 'Author2'
      acts_as_having_string_id
    end

    author = Author2.create!
    book = Book2.create! author: author

    assert author.id.is_a? Integer
    assert book.author_id.class <= Integer
  end

  test "has_many :through works" do
    class Cover < ApplicationRecord
      acts_as_having_string_id
    end

    class Book4 < ApplicationRecord
      self.table_name = 'books'
      has_many :covers, class_name: 'Cover', foreign_key: 'book_id'
      acts_as_having_string_id
    end

    class Author4 < ApplicationRecord
      self.table_name = 'authors'
      has_many :books, class_name: 'Book4', foreign_key: 'author_id'
      has_many :covers, through: :books
      acts_as_having_string_id
    end

    author = Author4.create!
    book = author.books.create!
    cover = book.covers.create!
    assert_includes author.covers, cover
  end

  test "has_and_belongs_to_many relationship works" do
    class Author5 < ApplicationRecord
      self.table_name = 'authors'
      has_and_belongs_to_many :publishers, foreign_key: 'author_id'
      acts_as_having_string_id
    end

    class Publisher < ApplicationRecord
      has_and_belongs_to_many :authors, class_name: 'Author5'
      acts_as_having_string_id
    end

    author = Author5.create!
    author.publishers.create!
  end
end
