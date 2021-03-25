class Sneaker < ApplicationRecord
	has_many_attached :photos
	belongs_to :user
	validates :size, :price, :condition, :serial_number, presence: true
	#Reflechir sur extras, box et name 
end
