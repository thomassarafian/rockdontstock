class Sneaker < ApplicationRecord
	validates :size, :price, :condition, :serial_number, presence: true
	#Reflechir sur extras, box et name 
end
