# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    super
    if session[:sneaker_session_id]
      @sneaker_session = Sneaker.where(id: session[:sneaker_session_id])
      @sneaker_session[0].update(user_id: current_user.id)
      @sneaker_session[0].save
      begin
        variable = Mailjet::Send.create(messages: [{
          'From'=> {
            'Email'=> "elliot@rockdontstock.com",
            'Name'=> "Rock Don't Stock"
          },
          'To'=> [
            {
              'Email'=> current_user.email,
              'Name'=> current_user.first_name,
            }
          ],
          'TemplateID'=> 2961370,
          'TemplateLanguage'=> true,
          'Subject'=> "Ta paire est en cours de validation ⌛",
          'Variables'=> {
            "prenom" => current_user.first_name,
            "modele_paire" => current_user.sneakers.last.sneaker_db.name,
          }
        }])
        p variable
      rescue Exception => e
        p e
      end
    end
    unless session[:sneaker_session_id].nil?
      session.delete(:sneaker_session_id)
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected
  
  # def after_sign_in_path_for(resource)
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
