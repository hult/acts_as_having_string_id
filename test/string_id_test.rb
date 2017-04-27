require 'test_helper'

class ActsAsHavingStringId::StringIdTest < ActiveSupport::TestCase
  test "initializing a StringId with a string works" do
    id = ActsAsHavingStringId::StringId.new(A, "Kp8obxHLxnq")
    assert_equal "Kp8obxHLxnq", id.string_value
    assert_equal 1, id.int_value
  end

  test "initializing a StringId with an int works" do
    id = ActsAsHavingStringId::StringId.new(A, 1)
    assert_equal "Kp8obxHLxnq", id.string_value
    assert_equal 1, id.int_value
  end

  test "inspecting a StringId with an int works" do
    id = ActsAsHavingStringId::StringId.new(A, 1)
    assert_equal "1/Kp8obxHLxnq", id.inspect
  end

  test "to_s returns the string value of a StringId" do
    id = ActsAsHavingStringId::StringId.new(A, 1)
    assert_equal "Kp8obxHLxnq", id.to_s
  end

  test "to_i returns the string value of a StringId" do
    id = ActsAsHavingStringId::StringId.new(A, 1)
    assert_equal 1, id.to_i
  end

  test "the equals method works" do
    assert_equal ActsAsHavingStringId::StringId.new(A, "Kp8obxHLxnq"),
      ActsAsHavingStringId::StringId.new(A, 1)
  end

  test "cast nil to nil" do
    string_id_type = ActsAsHavingStringId::StringId::Type.new(A)
    assert_nil string_id_type.cast(nil)
  end
end
