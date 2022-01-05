class Authentication < ApplicationRecord
  has_many_attached :photos, service: :cloudinary, dependent: :detach

  enum payment_status: { unpaid: 0, paid: 10 }
end
