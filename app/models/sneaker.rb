class Sneaker < ApplicationRecord
	has_many_attached :photos, dependent: :destroy
  has_many :orders, dependent: :destroy
	belongs_to :user

	validates :size, :price, :condition, presence: true
	#Reflechir sur extras, box et name 
  monetize :price_cents


	# after_create :send_notification  # a configurer avec mailjet 



  # after_create :link_sneaker_to_user, if: :user_is_connected?


	def send_notification
    UserMailer.new_sneaker(self, user).deliver
  end

  # def link_sneaker_to_user
  #   puts @sneaker
  #   puts @sneaker
  #   puts @sneaker
  #   puts @sneaker
  #   @sneaker.update(user_id: current_user.id)
  #   # current_user.update(sneaker_params)
  #   #.update(sneaker_params)
  #   # redirect_to sneaker_path(@sneaker)
  #   # sneaker.update(sneaker_params)
  # end

  # def user_is_connected?
  #   if current_user == nil
  #     return false
  #   else
  #     return true
  #   end
  # end

end
