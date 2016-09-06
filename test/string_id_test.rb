require 'test_helper'

class ActsAsHavingStringId::StringIdTest < ActiveSupport::TestCase
  test "serializing works" do
    string_id_type = ActsAsHavingStringId::StringId::Type.new(MyModel)
    id = MyModel.id_string(123456)
    assert_equal 123456, string_id_type.serialize(id)
  end
end
