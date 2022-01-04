class PagesController < ApplicationController
	skip_before_action :authenticate_user!, only: [:zswexddfe, :home, :about, :newsletter, :faq, :cgv, :cgu, :authentication, :how_to_send_shoes, :trust_policy]
	
  def home 
    @sneakers_selected = Sneaker.includes(:sneaker_db, :user, :orders, :photos_attachments, photos_attachments: :blob).selected.limit(8)
    @sneakers_selected = Sneaker.limit(8) if @sneakers_selected.empty?

    @sneakers_last_added = Sneaker.includes(:sneaker_db, :user, :orders, :photos_attachments, photos_attachments: :blob).where("state >= ?", 1).limit(8).order("created_at DESC")
    @sneakers_last_added = Sneaker.limit(8) if @sneakers_last_added.empty?
  end

  def about
  end
  
  def newsletter

    if !params[:email]&.match(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
      flash.now[:alert] = "Adresse email invalide"
    end

    if subscription = Subscription.new(email: params[:email]).as_prospect
      redirect_to root_path, notice: "Félicitation ! Tu vas bientôt recevoir nos offres"
    elsif subscription['message'] == "Contact already exist"
      redirect_to root_path, notice:"Tu es dejà inscrit à notre newsletter"
    end
  end

end
