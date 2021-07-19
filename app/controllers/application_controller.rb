class ApplicationController < ActionController::Base
	include Pagy::Backend
  include Pundit
	before_action :configure_permitted_parameters, if: :devise_controller?
	before_action :authenticate_user!
  before_action :set_search_navbar, unless: :skip_set_search_navbar?


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
    if params[:controller] == "sneaker_dbs" && params[:action] == "index"
      return true
    else
      return false
    end
  end

  
  def set_search_navbar
    @pagy, @sneaker_dbs = pagy(SneakerDb.order(:name))
    if params[:category].present? || params[:price].present? || params[:release_date].present?
      session[:filter_params] = params
      filtering_params(params).each do |key, value|
        @sneaker_dbs = @sneaker_dbs.public_send("filter_by_#{key}", value) if value.present?
      end
    elsif params[:page].present? && params[:page] >= "2" && session[:filter_params].present?
      filtering_params(session[:filter_params]).each do |key, value|
        @sneaker_dbs = @sneaker_dbs.public_send("filter_by_#{key}", value) if value.present?
      end
    else 
      @sneaker_dbs = SneakerDb.order(:name)
    end


    # if params[:query].present? && (params[:category].present? || params[:price].present? || params[:release_date].present?)
      # @sneaker_dbs = @sneaker_dbs.search_by_name_category_sub_and_price(params[:query]).where(category: params[:category], price_cents: params[:price], release_date: params[:release_date])
    # end
    # if params[:query].present?
    #   @sneaker_dbs = @sneaker_dbs.search_by_name_category_sub_and_price(params[:query])
    # end
    
    # if session[:filter_price].present? || params[:category].present? || params[:price].present? || params[:release_date].present?
      # unless session[:filter_price].present?
        # session[:filter_price] = params[:price]
      # end
      # @pagy, @sneaker_dbs = pagy(SneakerDb.where(category: " ", price_cents: 1..100).order(:name))
      # @pagy, @sneaker_dbs = pagy(SneakerDb.where(price_cents: 1..).order(:name))
      # if params[:price].present?
      #   puts session[:filter_price]
      #   puts params[:price]
      #   puts get_price
      #   puts get_price
      #   puts get_price
      #   puts get_price
      #   @pagy, @sneaker_dbs = pagy(SneakerDb.where(price_cents: get_price).order(:name))
      # end
    # end
    
    # if params[:category].present?
      # @sneaker_dbs = SneakerDb.where(category: params[:category], price_cents: params[:price], release_date: params[:release_date])
      # raise
    # end
    
    respond_to do |format|
      format.html
      format.json 
      format.text { render partial: 'shared/list.html.erb', locals: { sneaker_dbs: @sneaker_dbs, params: params}, pagination: view_context.pagy_nav(@pagy) }
    end
  end

  def filtering_params(params)
    params.slice(:category, :price, :release_date)
  end


	def configure_permitted_parameters
		# For additional fields in app/views/devise/registrations/new.html.erb
		devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :token_account, :token_person, :stripe_account_id, :person_id, :customer_id, :date_of_birth, :'date_of_birth(3i)', :'date_of_birth(2i)', :'date_of_birth(1i)', :line1, :city, :postal_code, :phone, :iban])

		# For additional in app/views/devise/registrations/edit.html.erb
		devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :token_account, :token_person, :stripe_account_id, :person_id, :customer_id, :date_of_birth, :'date_of_birth(3i)', :'date_of_birth(2i)', :'date_of_birth(1i)', :line1, :city, :postal_code, :phone, :iban, ids: []])
	end

	private

	def skip_pundit?
		devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
	end
end
