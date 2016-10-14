module ActsAsHavingStringId
  class Railtie < Rails::Railtie
    config.to_prepare do
      unless ActiveRecord::Base.included_modules.include?(ActsAsHavingStringId)
        ActiveRecord::Base.include(ActsAsHavingStringId)
      end
    end
  end
end
