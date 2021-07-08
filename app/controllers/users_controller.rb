class UsersController < ApplicationController
	before_action :set_user, only: [:show, :edit, :update]

  def show
  end

	def edit
	end
	
	def update
		@user.update(user_params)
    @user.save!
    if @user.save
      respond_to do |format|
        format.html
        format.json { render json: { user: @user } }
      end
	   end
  end
	
  private

	def set_user
		@user = current_user
		authorize @user
	end

  def user_params
  	params.require(:user).permit(:first_name, :last_name, :token_account, :token_person, :stripe_account_id, :person_id, :customer_id, :date_of_birth, :'date_of_birth(3i)', :'date_of_birth(2i)', :'date_of_birth(1i)', :line1, :city, :postal_code, :phone, :iban, :picker_data ,ids: [])
  end

end
