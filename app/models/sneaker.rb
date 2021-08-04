class Sneaker < ApplicationRecord
	has_many_attached :photos, dependent: :destroy

  has_many :orders, dependent: :destroy
	belongs_to :user
  belongs_to :sneaker_db

	validates :size, presence: true
  validates :price, presence: true
  validates :condition, presence: true
  validates :box, presence: true
  validates :price, format: { with: /([\s\d]+)/ }
  validate :photos, if: :photos_limit_min
  monetize :price_cents


	# after_create :send_notification  # a configurer avec mailjet 




	def send_notification
    UserMailer.new_sneaker(self, user).deliver
  end

  private    
  
  def photos_limit_min
    # return false if self.photos.empty?
    errors.add(:photos, " You must to upload at least 7 images") if self.photos.length <= 7 || self.photos.empty?
    # errors.add(:photos, " You must to upload at least 7 images") if self.photos.length <= 7
    return false
  end

end
