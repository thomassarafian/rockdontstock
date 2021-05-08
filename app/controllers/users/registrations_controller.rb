# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
    # super
  # end

  # GET /resource/edit
  # def edit
  #   super
  #       p "AVAAAANT"
  #       p "AVAAAANT"
  #       p "AVAAAANT"
  #       p "AVAAAANT"
  #       p "AVAAAANT"
  #       p "AVAAAANT"
  #       p "AVAAAANT"
  #     if !current_user.token_account? && current_user.date_of_birth? && current_user.line1? && current_user.city? && current_user.postal_code? && current_user.phone? 
  #       create_connect_account
  #       p "LE USER A REMPLI TOUTE SES INFOS DONC ON LUI CRÉÉ UN COMPTE CONNECT"
  #     end 
  #     if current_user.ids[0] && current_user.ids[1] && current_user.ids[2]
  #       send_identity_document
  #     end
  # end

  # PUT /resource
  # def update
    # super
    # if !current_user.token_account? && current_user.date_of_birth? && current_user.line1? && current_user.city? && current_user.postal_code? && current_user.phone? 
    #   create_connect_account
    #   p "LE USER A REMPLI TOUTE SES INFOS DONC ON LUI CRÉÉ UN COMPTE CONNECT"
    # end 
    # if current_user.ids[0] && current_user.ids[1] && current_user.ids[2]
    #   send_identity_document
    # end
  # end

  # DELETE /resource
  def destroy
    sneakers = Sneaker.all.where(user_id: current_user.id)
    sneakers.each do |sneaker|
        sneaker.destroy
    end
    super
  end

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



end
