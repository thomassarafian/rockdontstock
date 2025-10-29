class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    user = User.find_for_facebook_oauth(request.env['omniauth.auth'])
    
    if session[:sneaker_session_id]
      @sneaker_session = Sneaker.where(id: session[:sneaker_session_id]).first
      if @sneaker_session.present?
        @sneaker_session.update(user_id: user.id)
        @sneaker_session.save
      end
    end

    if user.persisted?
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    else
      session['devise.facebook_data'] = request.env['omniauth.auth']
      redirect_to new_user_registration_url
    end
  end

  def google_oauth2
    user = User.create_from_google_data(request.env['omniauth.auth'])

    if session[:sneaker_session_id]
      @sneaker_session = Sneaker.where(id: session[:sneaker_session_id]).first
      if @sneaker_session.present?
        @sneaker_session.update(user_id: user.id)
        @sneaker_session.save
      end
    end

    if user.persisted?
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Google') if is_navigational_format?
    else
      session['devise.google_data'] = request.env['omniauth.auth']
      redirect_to new_user_registration_url
    end
  end
end