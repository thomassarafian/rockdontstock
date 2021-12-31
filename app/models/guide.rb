class Guide < ApplicationRecord
  has_one_attached :file, service: :cloudinary, dependent: :destroy
end
