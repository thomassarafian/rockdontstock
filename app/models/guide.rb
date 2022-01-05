class Guide < ApplicationRecord
  has_one_attached :file, service: :cloudinary, dependent: :destroy

  before_create :set_default_image

  private

  def set_default_image
    self.img_url = "/assets/oeil-rds.png"
  end
  
end
