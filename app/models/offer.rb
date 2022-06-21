class Offer < ApplicationRecord
  belongs_to :sneaker
  belongs_to :user

  monetize :amount_cents

  enum status: { accepted: 0, pending: 5, refused: 10 }
end
