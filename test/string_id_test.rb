require 'test_helper'

class ActsAsHavingStringId::StringIdTest < ActiveSupport::TestCase
  test "serializing works" do
    tea = ActsAsHavingStringId::TEA.new('test')
    string_id = ActsAsHavingStringId::StringId.new(tea)
    id = tea.encrypt(123456).base62_encode
    assert_equal tea.decrypt(id.base62_decode), string_id.serialize(id)
  end

  test "to prevent postgres overflows, large numbers are serialized as -1" do
    tea = ActsAsHavingStringId::TEA.new('test')
    string_id = ActsAsHavingStringId::StringId.new(tea)
    id = tea.encrypt(2**31).base62_encode
    assert_equal -1, string_id.serialize(id)
  end
end
