class Track < ApplicationRecord
  belongs_to :album
  has_many :sales, as: :origin
end