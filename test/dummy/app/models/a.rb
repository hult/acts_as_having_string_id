class A < ApplicationRecord
  has_many :bs
  has_many :cs, through: :bs
  has_and_belongs_to_many :ds
  has_one :e
  belongs_to :f, optional: true

  acts_as_having_string_id
end
