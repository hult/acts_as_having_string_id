require 'test_helper'

class ActsAsHavingStringId::Test < ActiveSupport::TestCase
  test "id is a StringId" do
    m = MyModel.create!
    assert m.id.is_a?(ActsAsHavingStringId::StringId)
  end

  test "id_string class method works" do
    assert_equal "GBpjdLndSR0", MyModel.id_string(1)
  end

  test "id_int class method works" do
    assert_equal 1, MyModel.id_int("GBpjdLndSR0")
  end

  test "allows finding by both int, string and StringId" do
    m = MyModel.create!
    ns = MyModel.find(m.id.to_s)
    assert_equal m, ns
    ni = MyModel.find(m.id.to_i)
    assert_equal m, ni
    nsi = MyModel.find(m.id)
    assert_equal m, nsi
  end

  test "allows having both int, string and StringId in a where statement" do
    m = MyModel.create!
    ns = MyModel.where(id: m.id.to_s).first
    assert_equal m, ns
    ni = MyModel.where(id: m.id.to_i).first
    assert_equal m, ni
    nsi = MyModel.where(id: m.id).first
    assert_equal m, nsi
  end

  test "assigning foreign keys both as int, string and StringId works" do
    si5 = ActsAsHavingStringId::StringId.new(MyModel, 5)
    o = MyOtherModel.new my_model_id: si5.to_i
    assert_equal si5, o.my_model_id
    o = MyOtherModel.new my_model_id: si5.to_s
    assert_equal si5, o.my_model_id
    o = MyOtherModel.new my_model_id: si5
    assert_equal si5, o.my_model_id
  end
end
