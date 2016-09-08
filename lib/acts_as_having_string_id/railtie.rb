module ActsAsHavingStringId
  class Railtie < Rails::Railtie
    config.to_prepare do
      unless ApplicationRecord.included_modules.include?(ActsAsHavingStringId)
        ApplicationRecord.include(ActsAsHavingStringId)
      end
    end
  end
end
