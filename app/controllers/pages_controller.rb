class PagesController < ApplicationController
	skip_before_action :authenticate_user!, only: [:zswexddfe, :home, :about, :newsletter, :faq, :cgv, :cgu, :authentication, :how_to_send_shoes, :trust_policy]
	
  def home 
    @sneakers_selected = Sneaker.includes(:sneaker_db, :user, :orders, :photos_attachments, photos_attachments: :blob).where(selected: true).limit(8) || Sneaker.limit(8)
    @sneakers_last_added = Sneaker.includes(:sneaker_db, :user, :orders, :photos_attachments, photos_attachments: :blob).where("state >= ?", 1).limit(8).order("created_at DESC") || Sneaker.limit(8)
  end
  
  # def modal_bootstrap
  #    @sneakers_last_added = Sneaker.includes(:sneaker_db, :user,:photos_attachments, photos_attachments: :blob).where("state >= ?", 1).limit(8).order("created_at DESC")
  # end

  def about
  end
  
  def newsletter
    if params['user']['email'].present? && params['user']['email'].match(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
      @result = SubscribeToNewsletterService.new(params['user']).home_page_signup
      if @result['message'] == "Contact already exist"
        redirect_to root_path, alert:"Tu es dejà inscrit à notre newsletter"
      else
        redirect_to root_path, notice: "Félicitation ! Tu vas bientôt recevoir nos offres"
      end
    else 
      redirect_to root_path, alert: "Adresse email invalide"
    end
  end

  def zswexddfe
    @sneakers_selected = Sneaker.includes(:sneaker_db, :user,:photos_attachments, photos_attachments: :blob).where(id: [304, 276, 134, 122, 138, 152, 55, 56]) #.where("state = ?", 1).limit(8).order("created_at DESC")
  end

  private
  
  def newsletter_params
    params.permit(:user, :commit, :first_name, :email)
  end
end
