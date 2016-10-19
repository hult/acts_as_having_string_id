require 'test_helper'

class ActsAsHavingStringId::Test < ActiveSupport::TestCase
  test "id is a StringId" do
    m = MyModel.create!
    assert m.id.is_a?(ActsAsHavingStringId::StringId)
  end

  test "id_string and id_int class methods work" do
    assert_equal "GBpjdLndSR0", MyModel.id_string(1)
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

  test "finding by an invalid string id gives a 404" do
    assert_raises ActiveRecord::RecordNotFound do
      MyModel.find("alice@example.com")
    end
  end

  test "following a has_many :through relation works" do
    my_model = MyModel.create!
    my_other_model = MyOtherModel.create! my_model: my_model
    detail = Detail.create! my_other_model: my_other_model
    assert_includes my_model.details, detail
  end
end
