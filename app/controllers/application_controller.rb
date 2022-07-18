class ApplicationController < ActionController::Base
	include Pagy::Backend

	before_action :store_user_location!, if: :storable_location?
	before_action :configure_permitted_parameters, if: :devise_controller?
	before_action :authenticate_user!

	protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
	
	protected
	
	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(
			:sign_up,
			keys: [:first_name, :last_name, :token_account, :token_person, :stripe_account_id, :person_id, :customer_id, :date_of_birth, :'date_of_birth(3i)', :'date_of_birth(2i)', :'date_of_birth(1i)', :line1, :city, :postal_code, :instagram, :phone, :iban],
		)
		devise_parameter_sanitizer.permit(
			:account_update,
			keys: [:first_name, :last_name, :token_account, :token_person, :stripe_account_id, :person_id, :customer_id, :date_of_birth, :'date_of_birth(3i)', :'date_of_birth(2i)', :'date_of_birth(1i)', :line1, :city, :postal_code, :instagram, :phone, :iban, ids: []],
		)
	end

	private

	def storable_location?
		request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
	end

	def store_user_location!
		store_location_for(:user, request.fullpath)
	end
	
end
