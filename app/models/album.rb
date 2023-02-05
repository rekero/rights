class Album < ApplicationRecord
  has_many :sales, as: :origin
end