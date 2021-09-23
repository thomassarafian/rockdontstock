class Order < ApplicationRecord
  STATES = [
    "En cours",
    "Payé",
    "Validé",
    "Refusé",
    #Status -> Sendcloud Webhook
  ]

  belongs_to :user
  belongs_to :sneaker

  monetize :price_cents
  monetize :shipping_cost_cents
  monetize :service_cents

  # validates :state, inclusion: { in: STATES } # Pareil pour les sneakers -> permet d'etre sur que l'order est tjrs le statut 


  after_create :shipping_price
  before_update :create_sendcloud_label, unless: :order_is_not_paid?



  def order_is_not_paid?
    if self.state_changed? && self.state == "Payé"
      return false
    else
      return true
    end
  end

  def create_sendcloud_label
    SendcloudCreateLabel.new(self.user, self).create_label
  end

  def percent_of(a, n)
    a.to_f * (n.to_f / 100.0)
  end

  def shipping_price
  	# self.shipping_cost_cents = 490
    self.service = (percent_of((self.sneaker.price_cents / 100), 12))
    self.save
  end

end
