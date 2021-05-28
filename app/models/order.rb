class Order < ApplicationRecord
  belongs_to :user
  belongs_to :sneaker
  monetize :price_cents
  monetize :insurance_cents
  monetize :shipping_cost_cents

  after_create :shipping_price

  def shipping_price
  	case self.sneaker.price_cents / 100
  	when 50..124
  		  self.insurance_cents = 200
  	when 125..249
			self.insurance_cents = 350
  	when 250..374
			self.insurance_cents = 500
  	when 375..499
			self.insurance_cents = 650
  	when 500..1000
			self.insurance_cents = 800
  	end
  	self.shipping_cost_cents = 490
  end

end
