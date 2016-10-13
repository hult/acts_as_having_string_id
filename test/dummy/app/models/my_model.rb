class MyModel < ApplicationRecord
  has_many :my_other_models
  has_many :details, through: :my_other_model
  acts_as_having_string_id
end
