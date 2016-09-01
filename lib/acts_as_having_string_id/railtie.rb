module ActsAsHavingStringId
  class Railtie < Rails::Railtie
    initializer "railtie.include_in_application_record" do
      ApplicationRecord.include(ActsAsHavingStringId)
    end
  end
end
