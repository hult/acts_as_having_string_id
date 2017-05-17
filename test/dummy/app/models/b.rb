class B < ApplicationRecord
  has_many :cs
  belongs_to :a

  acts_as_having_string_id
end
