module ActsAsHavingStringId
  class StringId
    attr_accessor :string_value, :int_value

    def initialize(klass, value)
      puts "INITIALIZE #{klass.name} '#{value.inspect}' #{value.class}"
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
      "#{int_value} (\"#{string_value}\")"
    end

    class Type < ActiveRecord::Type::Value
      def initialize(klass)
        @klass = klass
      end

      # def type
      #   puts "TYPE CALLED"
      #   :string  # TOOD: what?
      # end

      def cast(value)
        puts "CAST '#{value}' #{value.class.name}"
        ActsAsHavingStringId::StringId(@klass, value)
      end

      def deserialize(value)
        puts "DESERIALIZE '#{value}' #{value.class.name}"
        if value.is_a?(String) || value.is_a?(Fixnum)
          ActsAsHavingStringId::StringId(@klass, value)
        else
          super
        end
      end

      def serialize(value)
        puts "SERIALIZE '#{value.inspect}' #{value.class.name}"
        ActsAsHavingStringId::StringId(@klass, value).int_value
      end
    end
  end

  def self.StringId(klass, value)
    value.is_a?(StringId) ? value : StringId.new(klass, value)
  end
end
