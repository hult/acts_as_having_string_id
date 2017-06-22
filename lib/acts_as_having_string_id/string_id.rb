module ActsAsHavingStringId
  class StringId
    attr_reader :string_value, :int_value

    def initialize(klass, value)
      if value == nil
        @string_value = nil
        @int_value = nil
      elsif value.is_a? String
        @string_value = value
        @int_value = klass.id_int(value)
      else
        @int_value = value
        @string_value = klass.id_string(value)
      end
    end

    def inspect
      "#{int_value}/#{string_value}"
    end

    def id
      int_value
    end

    def quoted_id
      int_value
    end

    def to_s
      string_value
    end

    def to_i
      int_value
    end

    def ==(other)
      other.is_a?(StringId) && other.int_value == int_value
    end

    class Type < ActiveRecord::Type::Integer
      def initialize(klass)
        super()
        @klass = klass
      end

      def deserialize(value)
        if value.is_a?(String) || value.class <= Integer
          ActsAsHavingStringId::StringId(@klass, value)
        else
          value
        end
      end

      def serialize(value)
        result = cast(value)
        if result
          ensure_in_range(result.to_i)
        end
        result
      end

      private

      def cast_value(value)
        ActsAsHavingStringId::StringId(@klass, value)
      end
    end
  end

  def self.StringId(klass, value)
    value.is_a?(StringId) ? value : StringId.new(klass, value)
  end
end
