module ActsAsHavingStringId
  class StringId
    class Type < ActiveRecord::Type::Value
      def initialize(tea)
        @tea = tea
      end

      def serialize(value)
        if value.is_a? String
          i = @tea.decrypt(value.base62_decode)
          if i >= 2**31
            # Since Postgres SERIAL is a signed 32-bit integer, we can
            # only represent integers up until (2**32)-1. If we're
            # serializing a larger id, we want a not found rather than
            # a postgres datatype out of bounds error. WHERE id = -1
            # will definitely not be found.
            return -1
          end
          return i
        else
          value
        end
      end
    end
  end
end
