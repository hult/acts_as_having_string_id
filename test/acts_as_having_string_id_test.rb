require 'test_helper'
require 'acts_as_having_string_id'

class ActsAsHavingStringId::Test < ActiveSupport::TestCase
  models = [:Author, :Book]

  i_suck_and_my_tests_are_order_dependent!

  setup do
    models.each do |m|
      load "./test/dummy/app/models/#{m.to_s.underscore}.rb"
      Object.const_get(m)
    end
  end

  teardown do
    models.each do |m|
      if Object.const_defined? m
        p "REMOVING #{m}"
        Object.send :remove_const, m
      end
    end
  end

  # test "your id a StringId" do
  #   class ::Author
  #     acts_as_having_string_id
  #   end
  #
  #   author = Author.create!
  #   assert author.id.is_a?(ActsAsHavingStringId::StringId)
  # end
  #
  # test "adds id_string and id_int class methods" do
  #   class Author
  #     acts_as_having_string_id
  #   end
  #
  #   assert_equal "Kp8obxHLxnq", Author.id_string(1)
  #   assert_equal 1, Author.id_int("Kp8obxHLxnq")
  # end
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
    class ::Author
      has_many :books
      acts_as_having_string_id
    end

    class ::Book
      belongs_to :author
      acts_as_having_string_id
    end

    author = Author.create!
    book = Book.create! author: author

    assert author.id.is_a? ActsAsHavingStringId::StringId
    assert book.id.is_a? ActsAsHavingStringId::StringId
    p book.author_id, book.author_id.class
    assert book.author_id.is_a? ActsAsHavingStringId::StringId
  end

  test "has_many/belongs_to relationship, only belonger string id" do
    puts 'BEFORE AUTHOR', Author.respond_to?(:acts_as_having_string_id?)

    class ::Author
      has_many :books
    end
    puts 'AFTER AUTHOR', Author.respond_to?(:acts_as_having_string_id?)

    class ::Book
      belongs_to :author
      acts_as_having_string_id
    end

    puts 'AFTER BOOK', Author.respond_to?(:acts_as_having_string_id?),
      Author.respond_to?(:id_string)

    author = Author.create!
    book = Book.create! author: author

    assert author.id.is_a? Integer
    p book.author_id.class
    assert book.author_id.class <= Integer
  end
end
