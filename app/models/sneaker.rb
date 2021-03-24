class Sneaker < ApplicationRecord
	belongs_to :user
	validates :size, :price, :condition, :serial_number, presence: true
	#Reflechir sur extras, box et name 
end
