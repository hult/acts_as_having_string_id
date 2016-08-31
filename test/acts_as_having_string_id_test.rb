require 'test_helper'

class ActsAsHavingStringId::Test < ActiveSupport::TestCase
  test "exposes an id_string method" do
    assert MyModel.new.respond_to? :id_string
  end

  test "id_string method works" do
    m = MyModel.new(id: 1)
    assert_equal "HIczBcO7kDa", MyModel.new(id: 1).id_string
  end

  test "allows finding by the string representation" do
    m = MyModel.create!
    n = MyModel.find(m.id_string)
    assert_equal m, n
  end

  test "finding by a very large id gives a record not found" do
    m = MyModel.new(id: 2**31)
    assert_raises ActiveRecord::RecordNotFound do
      MyModel.find m.id_string
    end
  end

  test "still allows finding by the sequential id" do
    m = MyModel.create!
    n = MyModel.find(m.id)
    assert_equal m, n
  end

  test "allows having the string representation in a where statement" do
    m = MyModel.create!
    n = MyModel.where(id: m.id_string).first
    assert_equal m, n
  end

  test "still allows having the sequential id in a where statement" do
    m = MyModel.create!
    n = MyModel.where(id: m.id).first
    assert_equal m, n
  end
end
