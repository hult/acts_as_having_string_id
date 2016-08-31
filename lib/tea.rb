#---------------------------------------------------------------------
# This is a pure ruby implementation of the Tiny Encryption Algorithm
# (TEA) by David Wheeler and Roger Needham of the Cambridge Computer
# Laboratory.
#
# For more information:
#
#   http://www.simonshepherd.supanet.com/tea.htm
#
# This is an implementation of the 'New Variant' of the cipher.
#
# ====================================================================
# Copyright (c) 2005, 2006 Jeremy Hinegardner <jeremy@hinegardner.org>
#
# This implementation of the TEA New Variant is released under
# the MIT License:
#
#   http://www.opensource.org/licenses/mit-license.html
#
# ====================================================================
#
# Altered for Gem suitability and to support encryption of 64-bit
# integers by Magnus Hult
#
#---------------------------------------------------------------------
# Ruby 1.8 compatibility
if RUBY_VERSION.include?('1.8')
  class Fixnum; def ord; return self; end; end
end
require 'digest/md5'
module ActsAsHavingStringId
  class TEA
    DELTA        = 0x9e3779b9
    ITERATIONS   = 32

    def initialize(pass_phrase)
      @key = passphrase_to_key(pass_phrase)
    end

    def encrypt(num)
      nums = to_32bit_ints(num)
      enc = encrypt_chunk(nums[0], nums[1], @key)
      from_32bit_ints(enc[0], enc[1])
    end

    def decrypt(num)
      nums = to_32bit_ints(num)
      dec = decrypt_chunk(nums[0], nums[1], @key)
      from_32bit_ints(dec[0], dec[1])
    end

    ############
    private
    ############

    def to_32bit_ints(num)
      # From a 64-bit integer, return an array of two 32-bit integers
      # high bits first
      [(num & 0xFFFFFFFF00000000) >> 32, num & 0x00000000FFFFFFFF]
    end

    def from_32bit_ints(num1, num2)
      # From two 32-bit integers, high bits first, return
      # a 64-bit integer
      (num1 << 32) | num2
    end

    #-------------------------------------------------------------
    # convert the given passphrase to and MD5 sum and get the 128
    # bit key as 4 x 32 bit ints
    #-------------------------------------------------------------
    def passphrase_to_key(pass_phrase)
      Digest::MD5.digest(pass_phrase).unpack('L*')
    end


    #-------------------------------------------------------------
    # encrypt 2 of the integers ( 8 characters ) of the input into
    # the cipher text output
    #-------------------------------------------------------------
    def encrypt_chunk(num1,num2,key)
      y,z,sum = num1,num2,0

      ITERATIONS.times do |i|
        y   += ( z << 4 ^ z >> 5) + z ^ sum + key[sum & 3]
        y   = y & 0xFFFFFFFF;

        sum += DELTA
        z   += ( y << 4 ^ y >> 5) + y ^ sum + key[sum >> 11 & 3]
        z   = z & 0xFFFFFFFF;

        # ruby can keep on getting bigger because of Bignum so
        # you have to and with 0xFFFFFFFF to get the Fixnum
        # bytes

      end
      return [y,z]
    end


    #-------------------------------------------------------------
    # decrypt 2 of the integer cipher texts into the plaintext
    #-------------------------------------------------------------
    def decrypt_chunk(num1,num2,key)
      y,z = num1,num2
      sum = DELTA << 5
      ITERATIONS.times do |i|
        z   -= ( y << 4 ^ y >> 5) + y ^ sum + key[sum >> 11 & 3]
        z    = z & 0xFFFFFFFF
        sum -= DELTA
        y   -= ( z << 4 ^ z >> 5) + z ^ sum + key[sum & 3]
        y    = y & 0xFFFFFFFF
      end
      return [y,z]
    end
  end
end
