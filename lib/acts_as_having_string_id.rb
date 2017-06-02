require 'base62'
require 'acts_as_having_string_id/tea'
require 'acts_as_having_string_id/string_id'
require 'acts_as_having_string_id/railtie' if defined?(Rails)

module ActsAsHavingStringId
  extend ActiveSupport::Concern

  module ClassMethods
    def acts_as_having_string_id(options = {})
      class_eval do
        def self.acts_as_having_string_id?
          # This class does act as having string id
          true
        end

        attrib_type = ActsAsHavingStringId::StringId::Type.new(self)
        attribute :id, attrib_type

        self.reflections.each_value do |r|
          if r.is_a?(ActiveRecord::Reflection::HasManyReflection)
            r.klass.class_eval do
              attribute r.foreign_key.to_sym, attrib_type
            end
          elsif r.is_a?(ActiveRecord::Reflection::BelongsToReflection)
            if r.klass.respond_to?(:acts_as_having_string_id?) && \
              r.klass.acts_as_having_string_id?
              foreign_attrib_type = ActsAsHavingStringId::StringId::Type.new(r.klass)
              attribute r.foreign_key.to_sym, foreign_attrib_type
            end
          end
        end

        def self.id_string(id)
          # Return the string representation of id
          _tea.encrypt(id).base62_encode
        end

        def self.id_int(id_string)
          # Return the id from a string representation
          begin
            id_int = id_string.base62_decode
          rescue
            return nil
          end
          _tea.decrypt(id_int)
        end
      end
    end

    def _tea
      pass_phrase = name + Rails.application.secrets.string_id_key
      @_tea ||= ActsAsHavingStringId::TEA.new(pass_phrase)
    end
  end
end
