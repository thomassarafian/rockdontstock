class Sneaker < ApplicationRecord
	has_many_attached :photos
	belongs_to :user
	validates :size, :price, :condition, presence: true
	#Reflechir sur extras, box et name 
  monetize :price_cents

	# after_create :send_notification  # a configurer avec mailjet 

	def send_notification
    UserMailer.new_sneaker(self, user).deliver
  end
end
