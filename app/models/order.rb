class Order < ApplicationRecord
  STATES = [
    "En cours",
    "Payé", # >>> sneaker.state = 2
    "Validé",
    "Refusé",
    "Abandon", # >>> sneaker.state = 1
    "En préparation", # <<< sneaker.state = 5
    "Expédiée"
    #Status -> Sendcloud Webhook
  ]
  
  enum payment_status: { unpaid: 0, paid: 10 }
  enum payment_method: { card: 0 }

  belongs_to :user
  belongs_to :sneaker

  monetize :total_price_cents
  monetize :shipping_fee_cents
  monetize :service_fee_cents

  validates :legal, acceptance: true
  # validates :state, inclusion: { in: STATES } # Pareil pour les sneakers -> permet d'etre sur que l'order est tjrs le statut 

  before_update :create_sendcloud_label, if: :order_is_paid?
  before_update :new_list_id_for_buyer, if: :order_is_paid?
  before_update :create_sendcloud_label_for_buyer, if: :order_is_in_preparation?

  # after_create :shipping_price


  def order_is_in_preparation?
    self.state_changed? && self.state == "En préparation"
  end

  def create_sendcloud_label_for_buyer
    SendcloudCreateLabelForBuyer.new(self.user, self).create_label
  end

  def order_is_paid?
    self.state_changed? && self.state == "Payé"
  end

  def create_sendcloud_label
    SendcloudCreateLabel.new(self.user, self).create_label
  end

  def new_list_id_for_buyer
    Subscription.new(self.user).as_buyer
  end

  # def shipping_price
  #   self.service = (percent_of((self.sneaker.price_cents / 100), 12))
  #   self.save
  # end

end
