class UsersController < ApplicationController
	before_action :set_sneaker, only: [:show, :edit, :update]

  def show
		@user = User.find(params[:id])
		authorize @user
  end

	def edit
	end
	
	def update
		current_user = @user
		@user.update(user_params)
		redirect_to user_path(@user)
	end

  private

	def set_sneaker
		@user = User.find(params[:id])
		authorize @user
	end

  def user_params
  	params.require(:user).permit(:first_name, :last_name, :token_account, :token_person, :stripe_account_id, :person_id, :customer_id, :'date_of_birth(3i)', :'date_of_birth(2i)', :'date_of_birth(1i)', :line1, :city, :postal_code, :phone, :iban, ids: [])
  end

end
