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
			if current_user.date_of_birth? && current_user.line1? && current_user.city? && current_user.postal_code? && current_user.phone?
				redirect_to sneaker_path(@sneaker), notice: "Ta paire a bien été envoyé !"
			else
				# Redirection vers son compte pour pouvoir y apporter les modifications + pop up pour indiquer que sa chaussure a bien ete submit
				redirect_to edit_user_registration_path(current_user), notice: "Ta paire a bien été envoyé ! Complète ton adresse, ta date de naissance et ton numéro de téléphone pour que des acheteurs puissent te l'acheter"
				#on créé pas automatiquement un compte connect ici car en realité si cote admin on valide la paire + le compte on créra un compte connect
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
		# il faut destroy toutes les orders qui dependent de @sneaker 
		
		orders = Order.all
		orders.each do |order|
			if order.sneaker.id == @sneaker.id
				order.destroy
			end
		end
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
end