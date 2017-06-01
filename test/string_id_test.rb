require 'test_helper'

class ActsAsHavingStringId::StringIdTest < ActiveSupport::TestCase
  Author = Class.new(ApplicationRecord) do
    self.table_name = 'authors'
    acts_as_having_string_id
  end

  test "initializing a StringId with a string works" do
    id = ActsAsHavingStringId::StringId.new(Author, "9E6Q4DAAEZO")
    assert_equal "9E6Q4DAAEZO", id.string_value
    assert_equal 1, id.int_value
  end

  test "initializing a StringId with an int works" do
    id = ActsAsHavingStringId::StringId.new(Author, 1)
    assert_equal "9E6Q4DAAEZO", id.string_value
    assert_equal 1, id.int_value
  end

  test "inspecting a StringId with an int works" do
    id = ActsAsHavingStringId::StringId.new(Author, 1)
    assert_equal "1/9E6Q4DAAEZO", id.inspect
  end

  test "to_s returns the string value of a StringId" do
    id = ActsAsHavingStringId::StringId.new(Author, 1)
    assert_equal "9E6Q4DAAEZO", id.to_s
  end

  test "to_i returns the string value of a StringId" do
    id = ActsAsHavingStringId::StringId.new(Author, 1)
    assert_equal 1, id.to_i
  end

  test "the equals method works" do
    assert_equal ActsAsHavingStringId::StringId.new(Author, "9E6Q4DAAEZO"),
      ActsAsHavingStringId::StringId.new(Author, 1)
  end

  test "cast nil to nil" do
    string_id_type = ActsAsHavingStringId::StringId::Type.new(Author)
    assert_nil string_id_type.cast(nil)
  end
end
