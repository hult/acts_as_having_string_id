class ApplicationRecord < ActiveRecord::Base
  include ActsAsHavingStringId

  self.abstract_class = true
end
