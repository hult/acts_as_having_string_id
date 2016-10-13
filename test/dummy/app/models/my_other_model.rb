class MyOtherModel < ApplicationRecord
  belongs_to :my_model
  has_many :details
end
