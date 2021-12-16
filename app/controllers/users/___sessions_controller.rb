# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:new]

  # GET /resource/sign_in
  # def new
  #   super
  #   if params['sneaker_id'].present?
  #     session[:sneaker_id_to_buy] = params['sneaker_id']
  #   end
  # end

  # POST /resource/sign_in
  # def create
  #   super
  #   if session[:sneaker_session_id]
  #     @sneaker_session = Sneaker.where(id: session[:sneaker_session_id])
  #     @sneaker_session[0].update(user_id: current_user.id)
  #     @sneaker_session[0].save
  #     begin
  #       variable = Mailjet::Send.create(messages: [{
  #         'From'=> {
  #           'Email'=> "elliot@rockdontstock.com",
  #           'Name'=> "Rock Don't Stock"
  #         },
  #         'To'=> [
  #           {
  #             'Email'=> current_user.email,
  #             'Name'=> current_user.first_name,
  #           }
  #         ],
  #         'TemplateID'=> 2961370,
  #         'TemplateLanguage'=> true,
  #         'Subject'=> "Ta paire est en cours de validation ⌛",
  #         'Variables'=> {
  #           "prenom" => current_user.first_name,
  #           "modele_paire" => current_user.sneakers.last.sneaker_db.name,
  #         }
  #       }])
  #       p variable
  #     rescue Exception => e
  #       p e
  #     end
  #     unless session[:sneaker_session_id].nil?
  #       session.delete(:sneaker_session_id)
  #     end
  #   end
  # end

  # protected

  # def after_sign_in_path_for(resource)
  #   stored_location_for(resource) || super
  # end

end
