# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    super
    if params['stripe-token-account'].present? && params['stripe-token-person'].present?
      @user.token_account = params['stripe-token-account']
      @user.token_person = params['stripe-token-person']
      if @user.save
        # if @user.stripe_account_id.present? && (@user.first_name_changed? || @user.last_name_changed? || @user.date_of_birth_changed? || @user.line1_changed? || @user.phone_changed?) && @user.token_account.present? && @user.token_person.present? && @user.token_person_changed? && @user.token_account_changed?
        #   Stripe::StripeUpdateConnectAccount.new(@user)  
        if !@user.stripe_account_id.present? && (@user.email? && @user.first_name? && @user.last_name? && @user.phone? && @user.line1? && @user.city? && @user.postal_code? && @user.date_of_birth.day.present? && @user.date_of_birth.month.present? && @user.date_of_birth.year.present?) && @user.token_account.present? && @user.token_person.present?
          Stripe::StripeCreateConnectAccount.new(@user)  
        end
      end
    end
    if @user.save
      if session[:sneaker_session_id]
        @sneaker_session = Sneaker.where(id: session[:sneaker_session_id]).first
        if @sneaker_session.present?
          @sneaker_session.update(user_id: @user.id)
          @sneaker_session.save
        end
        if Rails.env.production?
          begin
            variable = Mailjet::Send.create(messages: [{
              'From'=> {
                'Email'=> "elliot@rockdontstock.com",
                'Name'=> "Rock Don't Stock"
              },
              'To'=> [
                {
                  'Email'=> @user.email,
                  'Name'=> @user.first_name,
                }
              ],
              'TemplateID'=> 2961370,
              'TemplateLanguage'=> true,
              'Subject'=> "Ta paire est en cours de validation ⌛",
              'Variables'=> {
                "prenom" => @user.first_name || '',
                "modele_paire" => @user.sneakers.last&.sneaker_db&.name || 'Non spécifié',
              }
            }])
            p variable
          rescue Exception => e
            p e
          end
        end
      end
      unless session[:sneaker_session_id].nil?
        session.delete(:sneaker_session_id)
      end
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  def update
    if params['stripe-token-account'].present? && params['stripe-token-person'].present?
      @user.update_column(:token_account, params['stripe-token-account']) 
      @user.update_column(:token_person, params['stripe-token-person'])
    end
    if @user.stripe_account_id.present? #&& (self.first_name_changed? || self.last_name_changed? || self.date_of_birth_changed? || self.line1_changed? || self.phone_changed?) && self.token_account.present? && self.token_person.present? && self.token_person_changed? && self.token_account_changed?
      Stripe::StripeUpdateConnectAccount.new(@user)  
    elsif @user.stripe_account_id.nil?
      Stripe::StripeCreateConnectAccount.new(@user)
    end
    super
  end

  # DELETE /resource
  # def destroy
  #   sneakers = Sneaker.all.where(user_id: current_user.id)
  #   sneakers.each do |sneaker|
  #     sneaker.  destroy
  #   end
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
  
  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  # def after_update_path_for(resource)
  #   flash[:notice] = "Votre compte a bien été mise à jour !"
  #   user_path
  # end


end
