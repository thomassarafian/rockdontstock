class SneakersController < ApplicationController
	skip_before_action :authenticate_user!, only: [:index, :show]
	before_action :set_sneaker, only: [:show, :edit, :update, :destroy]
		
	def index
		@sneakers = policy_scope(Sneaker)
	end
	
	def show
	end
	
	def new
		@sneaker = Sneaker.new
		authorize @sneaker
	end
	
	def create
		@sneaker = current_user.sneakers.new(sneaker_params)
		authorize @sneaker
		if @sneaker.save
			@sneaker.update(state: 1) # ici on devrai laisser à 0, puis si on valide la paire cote admin, alors on la passera a 1 
			if current_user.date_of_birth.present? && current_user.line1.present? && current_user.city.present? && current_user.postal_code.present?
				redirect_to sneakers_path, notice: "Ta paire a bien été envoyé !"
				if current_user.token_account.nil?
					create_connect_account
				end
			else
				# Redirection vers son compte pour pouvoir y apporter les modifications + pop up pour indiquer que sa chaussure a bien ete submit
				redirect_to edit_user_registration_path(current_user), notice: "Ta paire a bien été envoyé ! Complète ton adresse, ta date de naissance et ton numéro de téléphone pour que des acheteurs puissent te l'acheter"
			end
		end
	end

	def edit
	end
	
	def update
		@sneaker.update(sneaker_params)
		redirect_to sneaker_path(@sneaker)
	end

	def destroy
		@sneaker.destroy
		redirect_to sneakers_path
	end

	private

	def sneaker_params
		params.require(:sneaker).permit(:name, :size, :price, :condition, :box, :extras, :state, photos: [])
	end

	def set_sneaker
		@sneaker = Sneaker.find(params[:id])
		authorize @sneaker
	end

	def create_connect_account
		stripe_create_token

		current_user.update(token_account: stripe_create_token.id)

    Stripe.api_key = ENV["STRIPE_SECRET_TEST"]
    
    stripe_account = Stripe::Account.create({
      account_token: current_user.token_account,
      type: 'custom',
      business_profile: {
        mcc: 5691,
        url: "rockdontstock.com",
      },
      country: 'FR',
      email: current_user.email,
      capabilities: {
        card_payments: {requested: true},
        transfers: {requested: true},
      }
    })
	end

	def stripe_create_token
		Stripe.api_key = ENV["STRIPE_SECRET_TEST"]
		Stripe::Token.create({
	  account: {
	    business_type: "individual",
	    individual: {
	      email: current_user.email,
	      first_name: current_user.first_name,
	      last_name: current_user.last_name,
	      phone: "+33606060606",
	      address: {
	      	line1: current_user.line1,
	      	city: current_user.city,
	      	postal_code: current_user.postal_code,
	      },
	      dob: {
	      	day: current_user.date_of_birth.day,
	      	month: current_user.date_of_birth.month,
	      	year: current_user.date_of_birth.year,
	      }

	    },
	    tos_shown_and_accepted: true,
	  },
	})
	end



end