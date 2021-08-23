# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    if params['user']['email'] == "elliot@rockdontstock.com" || params['user']['email'] == "nils@rockdontstock.com" || params['user']['email'] == "thomassarafian@gmail.com" 
      super
    else
      redirect_to root_path, alert: "Tu n'es pas admin"
    end
  end

  # POST /resource/sign_in
  def create
    super
    if session[:sneaker_session_id]
      @sneaker_session = Sneaker.where(id: session[:sneaker_session_id])
      @sneaker_session[0].update(user_id: current_user.id)
      @sneaker_session[0].save
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
