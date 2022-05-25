class Product < ApplicationRecord
  has_many :authentications
  
  def price
    '%.2f' % (price_in_cents / 100.00)
  end

  def list_items
    [li1, li2, li3, li4]
  end
end
