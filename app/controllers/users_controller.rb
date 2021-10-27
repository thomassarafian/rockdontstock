class UsersController < ApplicationController
	before_action :set_user, only: [:show, :edit, :update]

  def show
  end

	def edit
	end
	
	def update
    if params['user']['iban'].present?
      @res = Stripe::StripeSendIban.new(current_user, params['user']['iban']).call
      if !@res 
        redirect_to user_transfers_path, alert: "Erreur de vérification de l'IBAN."
      end
    end
    if params['stripe-token-account'].present? && params['stripe-token-person'].present?
      @user.update_column(:token_account, params['stripe-token-account']) 
      @user.update_column(:token_person, params['stripe-token-person'])
    end
		@user.update(user_params)
    @user.save!
    # if @user.save
      # respond_to do |format|
      #   format.html
      #   format.js 
        # format.json { render json: { user: @user } }
      # end
	   # end
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
