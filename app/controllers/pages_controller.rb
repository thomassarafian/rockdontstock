class PagesController < ApplicationController
	skip_before_action :authenticate_user!, only: [:home, :about, :newsletter]
	def home
  end
  
  def about
  end
  
  def newsletter
    # newsletter_params
    if params['user']['email'].present? && params['user']['email'].match(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
      @result = SubscribeToNewsletterService.new(params['user']).home_page_signup
      if @result == "Tu es dejà inscrit à notre newsletter"
        flash[:alert] = "Tu es dejà inscrit à notre newsletter"  
        render :home
      end
    else 
      flash[:alert] = "Adresse email invalide"
      render :home
    end
  end
  
  private
  
  def newsletter_params
    params.permit(:user, :commit, :first_name, :email)
  end
end
