class Order < ApplicationRecord
  belongs_to :user
  belongs_to :sneaker
  monetize :price_cents
end
