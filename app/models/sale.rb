class Sale < ApplicationRecord
  belongs_to :origin, polymorphic: true
end