class Order < ApplicationRecord
  STATES = [
    "En cours",
    "Payé",
    "Validé",
    "Refusé",
    "Abandon",
    "En préparation",
    "Expédiée"
    #Status -> Sendcloud Webhook
  ]

  belongs_to :user
  belongs_to :sneaker

  monetize :price_cents
  monetize :shipping_cost_cents
  monetize :service_cents

  # validates :state, inclusion: { in: STATES } # Pareil pour les sneakers -> permet d'etre sur que l'order est tjrs le statut 

  before_update :create_sendcloud_label, unless: :order_is_not_paid?

  before_update :create_sendcloud_label_for_buyer, unless: :order_is_not_in_preparation?

  after_create :shipping_price

  def order_is_not_in_preparation?
    if self.state_changed? && self.state == "En préparation"
      return false
    else
      return true
    end
  end

  def create_sendcloud_label_for_buyer
    puts "JE PASSE DANS create_sendcloud_label_for_buyer"
    SendcloudCreateLabelForBuyer.new(self.user, self).create_label
  end

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
    self.service = (percent_of((self.sneaker.price_cents / 100), 12))
    self.save
  end

end
