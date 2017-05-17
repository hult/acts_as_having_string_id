class C < ApplicationRecord
  belongs_to :b

  acts_as_having_string_id
end
