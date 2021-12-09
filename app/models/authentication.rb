class Authentication < ApplicationRecord
  has_many_attached :photos, service: :cloudinary, dependent: :detach
end
