class SneakersController < ApplicationController
	skip_before_action :authenticate_user!, only: [:index, :show, :new, :create]
  skip_after_action :verify_authorized, only: [:new, :create]

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
    if current_user == nil
      reset_session

      @sneaker = Sneaker.new(user_id: 1, name: params['sneaker']['name'],
        size: params['sneaker']['size'], condition: params['sneaker']['condition'], 
        price: params['sneaker']['price'], photos: params['sneaker']['photos'],
        box: params['sneaker']['box'], extras: params['sneaker']['extras'])
      
      @sneaker.save!
      
      session[:sneaker_session_id] = @sneaker.id
      redirect_to new_user_session_path, notice: "Tu dois être connecté pour que nous puissions vérifier ta paire"





    elsif current_user?
      @sneaker = current_user.sneakers.new(sneaker_params)
  		authorize @sneaker
    end
		# if @sneaker.save
		# 	@sneaker.update(state: 1) # ici on devrai laisser à 0, puis si on valide la paire cote admin, alors on la passera a 1 
		# 	if current_user == nil
  #       redirect_to new_user_session_path, notice: "Tu dois être connecté pour que nous puissions vérifier ta paire"
  #     elsif current_user? && current_user.date_of_birth? && current_user.line1? && current_user.city? && current_user.postal_code? && current_user.phone?
		# 		redirect_to sneaker_path(@sneaker), notice: "Ta paire a bien été envoyé !"
		# 	else
		# 		# Redirection vers son compte pour pouvoir y apporter les modifications + pop up pour indiquer que sa chaussure a bien ete submit
		# 		redirect_to edit_user_registration_path(current_user), notice: "Ta paire a bien été envoyé ! Complète ton adresse, ta date de naissance et ton numéro de téléphone pour que des acheteurs puissent te l'acheter"
		# 		#on créé pas automatiquement un compte connect ici car en realité si cote admin on valide la paire + le compte on créra un compte connect
		# 	end
		# end
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
end