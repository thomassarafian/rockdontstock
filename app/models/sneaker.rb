class Sneaker < ApplicationRecord
	has_many_attached :photos, dependent: :destroy
  has_many :orders, dependent: :destroy
	belongs_to :user
  belongs_to :sneaker_db

	validates :size, :price, :condition, presence: true
	
  #Reflechir sur extras, box et name 
  monetize :price_cents


	# after_create :send_notification  # a configurer avec mailjet 

  # after_create :link_sneaker_to_user, if: :user_is_connected?


	def send_notification
    UserMailer.new_sneaker(self, user).deliver
  end

end
