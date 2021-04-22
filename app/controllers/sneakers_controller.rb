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
		token = current_user.token_account
		# if !token.exist?

		# end
		# Stripe.api_key = "sk_test_51IcAgiE0gVjPTo06HW48ao4RFNjSSdbtFPFBAEIuhE3LP06VTI4Dxwn4rZ6cEl1INezpaFaeEE17AjC3Eppp5peJ00806puwmY"#ENV["STRIPE_SECRET_TEST"]
		# stripe_account = Stripe::Account.create({
		# 	type: 'custom',
		# 	country: 'FR',
		# 	email: current_user.email,
		# 	capabilities: {
		#     card_payments: {requested: true},
		#     transfers: {requested: true},
  # 		},
  # 		account_token: token
		# })
		
		# @sneaker.user_id = stripe_account.id 
		
		# account_link = Stripe::AccountLink.create({
		#   account: stripe_account.id,
		#   type: 'account_onboarding',
		#   refresh_url: sneakers_url,
		#   return_url: sneakers_url
		# })

		if @sneaker.save
			redirect_to sneaker_path(@sneaker) #account_link.url
			# redirect_to sneaker_path(@sneaker), notice: 'Ta paire a bien été ajouté'
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
		params.require(:sneaker).permit(:name, :size, :price, :condition, :box, :extras, photos: [])
	end

	def set_sneaker
		@sneaker = Sneaker.find(params[:id])
		authorize @sneaker
	end
end
