require 'base62'
require 'acts_as_having_string_id/tea'
require 'acts_as_having_string_id/string_id'
require 'acts_as_having_string_id/railtie' if defined?(Rails)

module ActsAsHavingStringId
  extend ActiveSupport::Concern

  module ClassMethods
    def acts_as_having_string_id(options = {})
      class_eval do
        attribute :id, ActsAsHavingStringId::StringId.new(_tea)

        def self.id_string(id)
          # Return the string representation of id
          _tea.encrypt(id).base62_encode
        end

        def self.id_int(id_string)
          # Return the id from a string representation
          _tea.decrypt(id_string.base62_decode)
        end
      end

      include ActsAsHavingStringId::LocalInstanceMethods
    end

    def _tea
      pass_phrase = name + Rails.application.secrets.string_id_key
      @_tea ||= ActsAsHavingStringId::TEA.new(pass_phrase)
    end
  end

  module LocalInstanceMethods
    def id_string
      self.class.id_string(id)
    end
  end
end
