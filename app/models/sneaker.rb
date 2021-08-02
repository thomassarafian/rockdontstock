class Sneaker < ApplicationRecord
	has_many_attached :photos, dependent: :destroy
  has_many :orders, dependent: :destroy
	belongs_to :user
  belongs_to :sneaker_db

	validates :size, presence: true
  validates :price, presence: true
  validates :condition, presence: true

  validates :price, format: { with: /([\s\d]+)/, :multiline => true  }



  monetize :price_cents


	# after_create :send_notification  # a configurer avec mailjet 




	def send_notification
    UserMailer.new_sneaker(self, user).deliver
  end

end
