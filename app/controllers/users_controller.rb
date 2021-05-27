class UsersController < ApplicationController
	before_action :set_user, only: [:show, :edit, :update]

  def show
		@user = User.find(params[:id])
		authorize @user
  end

	def edit
	end
	
	def update
		@user.update(user_params)
		if @user.save!
			  render 'update'
			# redirect_to user_path(@user) # je ne connais pas les conséquences de ça, j'ai commenté pour pouvoir modifier avec remote : true dans payment#new l'adresse
		end

	end

	
  private

	def set_user
		@user = User.find(params[:id])
		authorize @user
	end

  def user_params
  	params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :token_account, :token_person, :stripe_account_id, :person_id, :customer_id, :'date_of_birth(3i)', :'date_of_birth(2i)', :'date_of_birth(1i)', :line1, :city, :postal_code, :phone, :iban, :picker_data, ids: [])
  end

end
