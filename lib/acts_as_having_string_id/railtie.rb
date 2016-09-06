module ActsAsHavingStringId
  class Railtie < Rails::Railtie
    initializer "railtie.include_in_application_record" do
      if defined?(Spring)
        Spring.after_fork do
          # This needs to happen every time Spring reloads
          ApplicationRecord.include(ActsAsHavingStringId)
        end
      else
        ApplicationRecord.include(ActsAsHavingStringId)
      end
    end
  end
end
