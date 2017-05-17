class E < ApplicationRecord
  belongs_to :a

  acts_as_having_string_id
end
