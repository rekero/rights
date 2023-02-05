class TransactionType < ApplicationRecord
  def release_sale?
    name.in? ['Physical Sales', 'Download Albums']
  end

  def track_sale?
    !release_sale?
  end
end