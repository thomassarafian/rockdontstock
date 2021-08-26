class PagesController < ApplicationController
	skip_before_action :authenticate_user!, only: [:home, :about, :newsletter, :faq, :cgv, :cgu, :authentification, :trust_policy]
	def home
  end
  
  def about
  end
  
  def newsletter
    # newsletter_params
    if params['user']['email'].present? && params['user']['email'].match(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
      @result = SubscribeToNewsletterService.new(params['user']).home_page_signup
      # raise
      if @result == "Tu es dejà inscrit à notre newsletter"
        redirect_to root_path, alert:"Tu es dejà inscrit à notre newsletter"
      else
        redirect_to root_path, notice: "Félicitation ! Tu vas bientôt recevoir nos offres"
      end
    else 
      redirect_to root_path, alert: "Adresse email invalide"
    end
  end

  
  private
  
  def newsletter_params
    params.permit(:user, :commit, :first_name, :email)
  end
end
