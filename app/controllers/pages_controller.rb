class PagesController < ApplicationController
	skip_before_action :authenticate_user!, only: [:home, :about, :newsletter, :faq, :cgv, :cgu, :authentication, :how_to_send_shoes, :trust_policy]
	
  def home 
    @sneakers_selected = Sneaker.includes(:sneaker_db, :user, :orders, :photos_attachments, photos_attachments: :blob).selected.limit(8)
    @sneakers_selected = Sneaker.limit(8) if @sneakers_selected.empty?

    @sneakers_last_added = Sneaker.includes(:sneaker_db, :user, :orders, :photos_attachments, photos_attachments: :blob).where("state >= ?", 1).limit(8).order("created_at DESC")
    @sneakers_last_added = Sneaker.limit(8) if @sneakers_last_added.empty?
  end
  
  def newsletter
    if Subscription.new(email: params[:email]).as_prospect
      redirect_to request.referer, notice: "Félicitations ! Tu vas bientôt recevoir nos offres"
    else
      redirect_to request.referer, notice: "Tu es dejà inscrit à notre newsletter"
    end
  end

  def guide
    # if Subscription.new(email: params[:email]).as_prospect
    #   redirect_to request.referer, notice: "Félicitations ! Tu vas bientôt recevoir nos offres"
    # else
    #   redirect_to request.referer, notice: "Tu es dejà inscrit à notre newsletter"
    # end
  end

end
