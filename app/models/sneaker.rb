class Sneaker < ApplicationRecord
	has_many_attached :photos
	belongs_to :user
	validates :size, :price, :condition, presence: true
	#Reflechir sur extras, box et name 

	after_create :send_notification #A ajouter pour les emails

	def send_notification
    UserMailer.new_sneaker(self, user).deliver
  end
end
