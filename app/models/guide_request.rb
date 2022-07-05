class GuideRequest < ApplicationRecord
  belongs_to :guide

  delegate :price_in_cents, to: :guide

  enum payment_status: { unpaid: 0, paid: 10 }
  enum payment_method: { card: 0 }

  validates :first_name, :last_name, :email, :date_of_birth, :newsletter, presence: true
  validates :newsletter, acceptance: true

  def price
    '%.2f' % (price_in_cents / 100.00)
  end
  
end