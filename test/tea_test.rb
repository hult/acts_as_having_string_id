require 'test_helper'

class ActsAsHavingStringId::TeaTest < ActiveSupport::TestCase
  test "encrypting a number gives expected results" do
    tea = ActsAsHavingStringId::TEA.new('test')
    plaintext = 10414838284579674484
    encrypted = tea.encrypt(plaintext)
    assert_equal 5979036006718970748, encrypted
  end

  test "decrypting encrypted numbers give the numbers back" do
    tea = ActsAsHavingStringId::TEA.new('test')
    (1..100000).each do |plaintext|
      encrypted = tea.encrypt(plaintext)
      decrypted = tea.decrypt(encrypted)
      assert_equal plaintext, decrypted
    end
  end

  test "encrypting with different keys yield different results" do
    tea = ActsAsHavingStringId::TEA.new('test')
    tea2 = ActsAsHavingStringId::TEA.new('test2')
    assert_not_equal tea.encrypt(123), tea2.encrypt(123)
  end
end
