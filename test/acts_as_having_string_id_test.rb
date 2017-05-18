require 'test_helper'
require 'acts_as_having_string_id'

class ActsAsHavingStringId::Test < ActiveSupport::TestCase
  test "your id a StringId" do
    class Author3 < ApplicationRecord
      self.table_name = 'authors'
      acts_as_having_string_id
    end

    author = Author3.create!
    assert author.id.is_a?(ActsAsHavingStringId::StringId)
  end

  test "adds id_string and id_int class methods" do
    class Author4 < ApplicationRecord
      self.table_name = 'authors'
      acts_as_having_string_id
    end

    assert_equal "6ZEuSzrFTNW", Author4.id_string(1)
    assert_equal 1, Author4.id_int("6ZEuSzrFTNW")
  end
  #
  # test "find supports int, string and StringId" do
  #   class Author
  #     acts_as_having_string_id
  #   end
  #
  #   author = Author.create!
  #
  #   author_by_string = Author.find(author.id.to_s)
  #   assert_equal author, author_by_string
  #
  #   author_by_int = Author.find(author.id.to_i)
  #   assert_equal author, author_by_int
  #
  #   author_by_string_id = Author.find(a.id)
  #   assert_equal author, author_by_string_id
  # end
  #
  # test "where statements support string, int and StringId" do
  #   class Author
  #     acts_as_having_string_id
  #   end
  #
  #   author = Author.create!
  #
  #   author_by_string = Author.where(id: author.id.to_s).first
  #   assert_equal author, author_by_string
  #
  #   author_by_int = Author.where(id: author.id.to_i).first
  #   assert_equal author, author_by_int
  #
  #   author_by_string_id = Author.where(id: a.id).first
  #   assert_equal author, author_by_string_id
  # end
  #
  # test "supports assigning foreign keys both as int, string and StringId" do
  #   class Book
  #     belongs_to :author
  #   end
  #
  #   class Author
  #     acts_as_having_string_id
  #   end
  #
  #   author_id = ActsAsHavingStringId::StringId.new(Author, 5)
  #
  #   book = Book.new author_id: author_id.to_s
  #   assert_equal author_id, book.author_id
  #
  #   book = Book.new author_id: author_id.to_i
  #   assert_equal author_id, book.a_id
  #
  #   book = B.new author_id: author_id
  #   assert_equal author_id, book.author_id
  # end
  #
  # test "finding by an invalid string id means not found" do
  #   class Author
  #     acts_as_having_string_id
  #   end
  #
  #   assert_raises ActiveRecord::RecordNotFound do
  #     Author.find("alice@example.com")
  #   end
  # end
  #
  # test "following a has_many :through relation works" do
  #   a = A.create!
  #   b = B.create! a: a
  #   c = C.create! b: b
  #   assert_includes a.cs, c
  # end

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
end
