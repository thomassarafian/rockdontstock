class GuideRequest < ApplicationRecord
  after_update :process_guide

  belongs_to :guide

  delegate :price_in_cents, to: :guide

  enum payment_status: { unpaid: 0, paid: 10 }
  enum payment_method: { card: 0 }

  validates :first_name, :last_name, :email, :date_of_birth, :newsletter, presence: true
  validates :newsletter, acceptance: true

  def price
    '%.2f' % (price_in_cents / 100.00)
  end

  private

  def process_guide
    if saved_change_to_payment_status && payment_status === 'paid'
      sib_guide_id = self.guide.sendinblue_list_id
      Subscription.new(self).to_guide(sib_guide_id)
    end
  end
  
end
