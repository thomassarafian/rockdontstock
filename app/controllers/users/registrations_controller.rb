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
    # if @user.save
        # Stripe::Customer.create({
        #   email: current_user.email,
        #   name: current_user.first_name + " " + current_user.last_name,
        #   description: 'Test customer new',
        # })
      # token_account = current_user.token_account
      # Stripe.api_key = ENV["STRIPE_SECRET_TEST"]
      
      # stripe_account = Stripe::Account.create({
      #   account_token: token_account,
      #   type: 'custom',
      #   business_profile: {
      #     mcc: 5691,
      #     url: "rockdontstock.com",
      #   },
      #   country: 'FR',
      #   email: current_user.email,
      #   capabilities: {
      #     card_payments: {requested: true},
      #     transfers: {requested: true},
      #   }
      # })
      # @user.update(stripe_account_id: stripe_account.id)

      # # # @user.stripe_account_id = stripe_account.id 
      
      # # # p "==============================="
      # # # p current_user.stripe_account_id
      # # # p "==============================="
      # # # p @user.stripe_account_id
      # # # p "==============================="
      
      # account_link = Stripe::AccountLink.create({
      #   account: stripe_account.id,
      #   type: 'account_onboarding',
      #   refresh_url: sneakers_url,
      #   return_url: sneakers_url
      # })
    # end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
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
end
