require 'base62'
require 'tea.rb'
require 'string_id.rb'
require 'acts_as_having_string_id/railtie' if defined?(Rails)

module ActsAsHavingStringId
  extend ActiveSupport::Concern

  module ClassMethods
    def acts_as_having_string_id(options = {})
      class_eval do
        attribute :id, ActsAsHavingStringId::StringId.new(_tea)
      end
      include ActsAsHavingStringId::LocalInstanceMethods
    end

    def _tea
      pass_phrase = self.class.name + Rails.application.secrets.tea_key
      @_tea ||= ActsAsHavingStringId::TEA.new(pass_phrase)
    end
  end

  module LocalInstanceMethods
    def id_string
      self.class._tea.encrypt(id).base62_encode
    end
  end
end
