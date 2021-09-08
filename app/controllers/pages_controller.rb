class PagesController < ApplicationController
	skip_before_action :authenticate_user!, only: [:home, :about, :newsletter, :faq, :cgv, :cgu, :authentification, :how_to_send_shoes, :trust_policy]
	def home
    # if params['stripe-token-account']
    
    # stripe_account = Stripe::Account.create({
    #   account_token: params['stripe-token-account'],
    #   type: 'custom',
    #   business_profile: {
    #     mcc: 5691,
    #     url: "rockdontstock.com",
    #   },
    #   country: 'FR',
    #   email: params['user_email'],
    #   capabilities: {
    #     card_payments: {requested: true},
    #     transfers: {requested: true},
    #   }
    # })
    # puts '=============================='
    # puts "STRIPE PERSON ID ->"
    # puts stripe_account['individual'].id
    # puts '=============================='
    # puts "STRIPE ACCOUNT ID ->"
    # puts stripe_account.id
    # puts '=============================='
    # puts params
    # end

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
