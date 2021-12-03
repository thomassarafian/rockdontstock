class ApplicationController < ActionController::Base
	include Pagy::Backend
	include Pundit
	before_action :configure_permitted_parameters, if: :devise_controller?
	before_action :authenticate_user!

	# before_action :set_search_navbar, unless: :skip_set_search_navbar?

	# Pundit: white-list approach.
	after_action :verify_authorized, except: :index, unless: :skip_pundit?
	after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

	protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

	# Uncomment when you *really understand* Pundit!
	# rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
	# def user_not_authorized
	#   flash[:alert] = "You are not authorized to perform this action."
	#   redirect_to(root_path)
	# end

	protected

	def skip_set_search_navbar?
		if (params[:controller] == 'sneaker_dbs' && params[:action] == 'index') || params['_method'] == 'patch'
			return true
		else
			return false
		end
	end

	def configure_permitted_parameters
		# For additional fields in app/views/devise/registrations/new.html.erb
		devise_parameter_sanitizer.permit(
			:sign_up,
			keys: [:first_name, :last_name, :token_account, :token_person, :stripe_account_id, :person_id, :customer_id, :date_of_birth, :'date_of_birth(3i)', :'date_of_birth(2i)', :'date_of_birth(1i)', :line1, :city, :postal_code, :phone, :iban],
		)

		# For additional in app/views/devise/registrations/edit.html.erb
		devise_parameter_sanitizer.permit(
			:account_update,
			keys: [:first_name, :last_name, :token_account, :token_person, :stripe_account_id, :person_id, :customer_id, :date_of_birth, :'date_of_birth(3i)', :'date_of_birth(2i)', :'date_of_birth(1i)', :line1, :city, :postal_code, :phone, :iban, ids: []],
		)
	end

	private

	def skip_pundit?
		devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
	end
end
