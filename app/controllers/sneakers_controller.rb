class SneakersController < ApplicationController

	before_action :set_sneaker, only: [:show, :edit, :update, :destroy]
	skip_before_action :authenticate_user!, only: [:index, :show, :new, :create]
	skip_after_action :verify_authorized, only: [:new, :create]

	def index
		results = policy_scope(Sneaker).where('state >= ?', 1).search_by_name_and_brand(params[:search])
		
		[:price, :condition, :size, :category].each do |filter|
			results = results&.public_send("filter_by_#{filter.to_s}", params[filter]) if params[filter].present?
		end

		@pagy, @results = pagy(results&.includes(:sneaker_db, :user, :photos_attachments, photos_attachments: :blob), items: 12)
	end

	def show
		@sneaker = Sneaker.find(params[:id])
	end

	def new
		@sneaker = Sneaker.new
		authorize @sneaker

		@sneaker_db = SneakerDb.find(params[:sneaker_db]) if params[:sneaker_db]

		respond_to do |format|
			format.js
			format.html
		end
	end

	def create
		@sneaker_db = SneakerDb.find(params['sneaker_db_id']) if params['sneaker_db_id'].present?
		if !params['button-new-sneaker'].present?
			if current_user == nil
				session.delete(:sneaker_session_id)
				@sneaker =
					Sneaker.new(
						user_id: 1,
						size: params['sneaker']['size'],
						condition: params['sneaker']['condition'],
						price: params['sneaker']['price'],
						photos: params['sneaker']['photos'],
						box: params['sneaker']['box'],
						extras: params['sneaker']['extras'],
						state: 0,
						sneaker_db_id: @sneaker_db.id,
					)
				@sneaker.save!
				session[:sneaker_session_id] = @sneaker.id
			elsif user_signed_in?
				@sneaker = current_user.sneakers.new(sneaker_db_id: @sneaker_db.id)
				@sneaker.update(sneaker_params)
				@sneaker.update(state: 0)
				authorize @sneaker
				@sneaker.save!
			end
		else
			if current_user == nil
				# @sneaker = Sneaker.new(user_id: 1,
				#   size: params['sneaker']['size'], condition: params['sneaker']['condition'],
				#   price: params['sneaker']['price'], photos: params['sneaker']['photos'],
				#   box: params['sneaker']['box'], extras: params['sneaker']['extras'],
				#   state: 0, sneaker_db_id: @sneaker_db.id)
				#   if !@sneaker.save
				#     render :new
				#   else
				# session[:sneaker_session_id] = @sneaker.id
				redirect_to new_user_session_path, notice: 'Tu dois être connecté pour que nous puissions vérifier ta paire'
				# end
			elsif user_signed_in?
				#  @sneaker = current_user.sneakers.new(sneaker_db_id: @sneaker_db.id)
				#  @sneaker.update(sneaker_params)
				# authorize @sneaker
				# if @sneaker.save
				# 	@sneaker.update(state: 0) # ici on devrai laisser à 0, puis si on valide la paire cote admin, alors on la passera a 1
				if user_signed_in? && current_user.date_of_birth? && current_user.line1? && current_user.city? && current_user.postal_code? && current_user.phone?
					redirect_to sneaker_path(current_user.sneakers.last), notice: 'Ta paire a bien été envoyé !'
				else
					# Redirection vers son compte pour pouvoir y apporter les modifications + pop up pour indiquer que sa chaussure a bien ete submit
					redirect_to edit_user_registration_path, notice: "Ta paire a bien été envoyé ! Complète ton adresse, ta date de naissance et ton numéro de téléphone pour que des acheteurs puissent te l'acheter"
					#on créé pas automatiquement un compte connect ici car en realité si cote admin on valide la paire + le compte on créra un compte connect
				end
				variable =
					Mailjet::Send.create(
						messages: [
							{
								'From' => {
									'Email' => 'elliot@rockdontstock.com',
									'Name' => "Rock Don't Stock",
								},
								'To' => [{ 'Email' => current_user.email, 'Name' => current_user.first_name }],
								'TemplateID' => 2_961_370,
								'TemplateLanguage' => true,
								'Subject' => 'Ta paire est en cours de validation ⌛',
								'Variables' => {
									'prenom' => current_user.first_name,
									'modele_paire' => current_user.sneakers.last.sneaker_db.name,
								},
							},
						],
					)
				# end
			end
		end
	end

	def edit; end

	def update
		if @sneaker.state == 0
			@sneaker.update(sneaker_params)
			redirect_to sneaker_path(@sneaker)
		else
			redirect_to root_path, notice: 'Tu ne pas pas modifié une paire déjà en ligne'
		end
	end

	def destroy
		@sneaker.photos.purge
		@sneaker.destroy
		redirect_to user_items_path
	end

	private

	def render_step(the_step, options = {}, params = {})
		if the_step.nil? || the_step.to_s == Wicked::FINISH_STEP
			redirect_to_finish_wizard options, params
		else
			respond_to do |format|
				format.js
				format.html
			end
		end
	end

	def filtering_params(params)
		params.slice(:price, :condition, :size, :category)
	end

	def sneaker_params
		params.require(:sneaker).permit(:sneaker_db_id, :name, :size, :price, :condition, :box, :extras, :state, photos: [])
	end

	def set_sneaker
		@sneaker = Sneaker.find(params[:id])
		authorize @sneaker
	end
end
