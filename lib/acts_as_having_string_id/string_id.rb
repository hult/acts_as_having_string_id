module ActsAsHavingStringId
  class StringId
    attr_accessor :string_value, :int_value

    def initialize(klass, value)
      if value == nil
        self.string_value = nil
        self.int_value = nil
      elsif value.is_a? String
        self.string_value = value
        self.int_value = klass.id_int(value)
      else
        self.int_value = value
        self.string_value = klass.id_string(value)
      end
    end

    def inspect
      "#{int_value}/#{string_value}"
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

    class Type < ActiveRecord::Type::Value
      def initialize(klass)
        @klass = klass
      end

      def type
        :integer
      end

      def cast(value)
        ActsAsHavingStringId::StringId(@klass, value)
      end

      def deserialize(value)
        if value.is_a?(String) || value.is_a?(Fixnum)
          ActsAsHavingStringId::StringId(@klass, value)
        elsif value == nil
          nil
        else
          super
        end
      end

      def serialize(value)
        ActsAsHavingStringId::StringId(@klass, value).int_value
      end
    end
  end

  def self.StringId(klass, value)
    value.is_a?(StringId) ? value : StringId.new(klass, value)
  end
end
