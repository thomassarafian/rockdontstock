class Order < ApplicationRecord
  belongs_to :user
  belongs_to :sneaker
  monetize :amount_cents
end
