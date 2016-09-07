require 'test_helper'

class ActsAsHavingStringId::StringIdTest < ActiveSupport::TestCase
  test "initializing a StringId with a string works" do
    id = ActsAsHavingStringId::StringId.new(MyModel, "GBpjdLndSR0")
    assert_equal "GBpjdLndSR0", id.string_value
    assert_equal 1, id.int_value
  end

  test "initializing a StringId with an int works" do
    id = ActsAsHavingStringId::StringId.new(MyModel, 1)
    assert_equal "GBpjdLndSR0", id.string_value
    assert_equal 1, id.int_value
  end

  test "inspecting a StringId with an int works" do
    id = ActsAsHavingStringId::StringId.new(MyModel, 1)
    assert_equal "1/GBpjdLndSR0", id.inspect
  end

  test "to_s returns the string value of a StringId" do
    id = ActsAsHavingStringId::StringId.new(MyModel, 1)
    assert_equal "GBpjdLndSR0", id.to_s
  end

  test "to_i returns the string value of a StringId" do
    id = ActsAsHavingStringId::StringId.new(MyModel, 1)
    assert_equal 1, id.to_i
  end

  test "the equals method works" do
    assert_equal ActsAsHavingStringId::StringId.new(MyModel, "GBpjdLndSR0"),
      ActsAsHavingStringId::StringId.new(MyModel, 1)
  end
end
