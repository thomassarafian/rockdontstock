class Order < ApplicationRecord
  belongs_to :user
  belongs_to :sneaker

  monetize :price_cents
  monetize :shipping_cost_cents
  monetize :service_cents


  after_create :shipping_price


  def percent_of(a, n)
    a.to_f * (n.to_f / 100.0)
  end

  def shipping_price
  	self.shipping_cost_cents = 490
    self.service = (percent_of((self.sneaker.price_cents / 100), 12))
  end

end
