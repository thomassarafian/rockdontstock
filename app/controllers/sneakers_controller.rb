class SneakersController < ApplicationController
	skip_before_action :authenticate_user!, only: [:index, :show]
	before_action :set_sneaker, only: [:show, :edit, :update, :destroy]

	def index
		@selection_of_the_day = Sneaker.highlighted.last || Sneaker.selected.last || Sneaker.where('state >= ?', 1).first
		results = Sneaker.where('state >= ?', 1).search_by_name_and_brand(params[:search])
		
		[:min_price, :max_price, :condition, :size, :category].each do |filter|
			results = results&.public_send("filter_by_#{filter.to_s}", params[filter]) if params[filter].present?
		end

		results = results.order(params[:sort_by]) if params[:sort_by]
		@pagy, @results = pagy(results&.includes(:sneaker_db, :photos_attachments, photos_attachments: :blob), items: 18)
		
		@referer = request.referer
		
		respond_to do |format|
      format.js
      format.html
    end
	end

	def show
		@sneaker = Sneaker.where('state >= ?', 1).find(params[:id])
		@price = if @offer = current_user.search_accepted_offer_on(@sneaker)
			@offer.amount
		else
			@sneaker.price
		end

		category = @sneaker.sneaker_db.category
		size = @sneaker.size
		price = @sneaker.price.to_i

		similar_by_category = Sneaker.where('state >= ?', 1).filter_by_category(category).limit(10)
		similar_by_size = Sneaker.where('state >= ?', 1).filter_by_size(size).limit(10)
		similar_by_price = Sneaker.where('state >= ?', 1).filter_by_min_price(price - 50).filter_by_max_price(price).limit(10)

		@similar_sneakers = similar_by_category + similar_by_size + similar_by_price
		@similar_sneakers = @similar_sneakers.uniq.sample(20) || Sneaker.all.sample(6)
	end

	def create
		# flash[:notice] = "En cours de ... Désolé, reviens un peu plus tard !"
		# redirect_to root_path and return
		@sneaker = Sneaker.create(user: current_user)
		redirect_to sneaker_build_path(@sneaker.id, :sneaker_db)
	end

	# def create
	# 	@sneaker_db = SneakerDb.find(params['sneaker_db_id']) if params['sneaker_db_id'].present?
	# 	if !params['button-new-sneaker'].present?
	# 		if current_user == nil
	# 			session.delete(:sneaker_session_id)
	# 			@sneaker =
	# 				Sneaker.new(
	# 					user_id: 1,
	# 					size: params['sneaker']['size'],
	# 					condition: params['sneaker']['condition'],
	# 					price: params['sneaker']['price'],
	# 					photos: params['sneaker']['photos'],
	# 					box: params['sneaker']['box'],
	# 					extras: params['sneaker']['extras'],
	# 					state: 0,
	# 					sneaker_db_id: @sneaker_db.id,
	# 				)
	# 			@sneaker.save!
	# 			session[:sneaker_session_id] = @sneaker.id
	# 		elsif user_signed_in?
	# 			@sneaker = current_user.sneakers.new(sneaker_db_id: @sneaker_db.id)
	# 			@sneaker.update(sneaker_params)
	# 			@sneaker.update(state: 0)
	# 			@sneaker.save!
	# 		end
	# 	else
	# 		if current_user == nil
	# 			# @sneaker = Sneaker.new(user_id: 1,
	# 			#   size: params['sneaker']['size'], condition: params['sneaker']['condition'],
	# 			#   price: params['sneaker']['price'], photos: params['sneaker']['photos'],
	# 			#   box: params['sneaker']['box'], extras: params['sneaker']['extras'],
	# 			#   state: 0, sneaker_db_id: @sneaker_db.id)
	# 			#   if !@sneaker.save
	# 			#     render :new
	# 			#   else
	# 			# session[:sneaker_session_id] = @sneaker.id
	# 			redirect_to new_user_session_path, notice: 'Tu dois être connecté pour que nous puissions vérifier ta paire'
	# 			# end
	# 		elsif user_signed_in?
	# 			#  @sneaker = current_user.sneakers.new(sneaker_db_id: @sneaker_db.id)
	# 			#  @sneaker.update(sneaker_params)
	# 			# if @sneaker.save
	# 			# 	@sneaker.update(state: 0) # ici on devrai laisser à 0, puis si on valide la paire cote admin, alors on la passera a 1
	# 			if user_signed_in? && current_user.date_of_birth? && current_user.line1? && current_user.city? && current_user.postal_code? && current_user.phone?
	# 				redirect_to sneaker_path(current_user.sneakers.last), notice: 'Ta paire a bien été envoyé !'
	# 			else
	# 				# Redirection vers son compte pour pouvoir y apporter les modifications + pop up pour indiquer que sa chaussure a bien ete submit
	# 				redirect_to edit_user_registration_path, notice: "Ta paire a bien été envoyé ! Complète ton adresse, ta date de naissance et ton numéro de téléphone pour que des acheteurs puissent te l'acheter"
	# 				#on créé pas automatiquement un compte connect ici car en realité si cote admin on valide la paire + le compte on créra un compte connect
	# 			end
	# 			variable =
	# 				Mailjet::Send.create(
	# 					messages: [
	# 						{
	# 							'From' => {
	# 								'Email' => 'elliot@rockdontstock.com',
	# 								'Name' => "Rock Don't Stock",
	# 							},
	# 							'To' => [{ 'Email' => current_user.email, 'Name' => current_user.first_name }],
	# 							'TemplateID' => 2_961_370,
	# 							'TemplateLanguage' => true,
	# 							'Subject' => 'Ta paire est en cours de validation ⌛',
	# 							'Variables' => {
	# 								'prenom' => current_user.first_name,
	# 								'modele_paire' => current_user.sneakers.last.sneaker_db.name,
	# 							},
	# 						},
	# 					],
	# 				)
	# 			# end
	# 		end
	# 	end
	# end

	def update
		if @sneaker.update(sneaker_params)
			redirect_to request.referer, notice: "Le prix de ta #{@sneaker.sneaker_db&.name} a été modifié avec succès"
		else
			redirect_to root_path, alert: @sneaker.errors.full_messages.join(', ')
		end
	end

	def destroy
		name = @sneaker.sneaker_db&.name
		@sneaker.photos.purge
		@sneaker.destroy
		redirect_to request.referer, notice: "L'annonce de ta #{name} a été supprimée avec succès"
	end

	private

	def sneaker_params
		params.require(:sneaker).permit(:price)
	end

	def set_sneaker
		@sneaker = Sneaker.find(params[:id])
	end
end
