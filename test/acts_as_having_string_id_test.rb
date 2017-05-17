require 'test_helper'

class ActsAsHavingStringId::Test < ActiveSupport::TestCase
  test "id is a StringId" do
    a = A.create!
    assert a.id.is_a?(ActsAsHavingStringId::StringId)
  end

  test "id_string and id_int class methods work" do
    assert_equal "Kp8obxHLxnq", A.id_string(1)
    assert_equal 1, A.id_int("Kp8obxHLxnq")
  end

  test "allows finding by both int, string and StringId" do
    a = A.create!
    ns = A.find(a.id.to_s)
    assert_equal a, ns
    ni = A.find(a.id.to_i)
    assert_equal a, ni
    nsi = A.find(a.id)
    assert_equal a, nsi
  end

  test "allows having both int, string and StringId in a where statement" do
    a = A.create!
    ns = A.where(id: a.id.to_s).first
    assert_equal a, ns
    ni = A.where(id: a.id.to_i).first
    assert_equal a, ni
    nsi = A.where(id: a.id).first
    assert_equal a, nsi
  end

  test "assigning foreign keys both as int, string and StringId works" do
    si5 = ActsAsHavingStringId::StringId.new(A, 5)
    b = B.new a_id: si5.to_i
    assert_equal si5, b.a_id
    b = B.new a_id: si5.to_s
    assert_equal si5, b.a_id
    b = B.new a_id: si5
    assert_equal si5, b.a_id
  end

  test "finding by an invalid string id gives a 404" do
    assert_raises ActiveRecord::RecordNotFound do
      A.find("alice@example.com")
    end
  end

  test "following a has_many :through relation works" do
    a = A.create!
    b = B.create! a: a
    c = C.create! b: b
    assert_includes a.cs, c
  end

  test "has_many relationship" do
    a = A.create!
    b = B.create! a: a

    refute a.respond_to? :a_id
    refute a.respond_to? :b_id
    assert b.a_id.is_a? ActsAsHavingStringId::StringId
    refute b.respond_to? :b_id
  end

  test "has_many :through relationship" do
    a = A.create!
    b = B.create! a: a
    c = C.create! b: b

    refute a.respond_to? :c_id
    refute c.respond_to? :a_id
  end

  test "has_one relationship" do
    a = A.create!
    e = ::E.create! a: a

    refute a.respond_to? :e_id
    assert e.a_id.is_a? ActsAsHavingStringId::StringId
  end
end
