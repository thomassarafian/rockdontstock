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
    if session[:sneaker_session_id]
      @user.save
      @sneaker_session = Sneaker.where(id: session[:sneaker_session_id])
      @sneaker_session[0].update(user_id: @user.id)
      @sneaker_session[0].save
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
          "prenom" => @user.first_name,
          "modele_paire" => @user.sneakers.last.sneaker_db.name,
        }
      }])
    end
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

  def after_update_path_for(resource)
    flash[:notice] = "Votre compte a bien été mise à jour !"
    user_path
  end


end
