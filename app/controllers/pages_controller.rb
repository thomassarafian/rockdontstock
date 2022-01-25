class PagesController < ApplicationController
	skip_before_action :authenticate_user!, only: [:home, :about, :newsletter, :faq, :cgv, :cgu, :authentication, :how_to_send_shoes, :trust_policy, :guide_request]
	
  def home 
    @sneakers_selected = Sneaker.includes(:sneaker_db, :user, :orders, :photos_attachments, photos_attachments: :blob).selected.last(8)
    @sneakers_selected = Sneaker.limit(8) if @sneakers_selected.empty?

    @sneakers_last_added = Sneaker.includes(:sneaker_db, :user, :orders, :photos_attachments, photos_attachments: :blob).where("state >= ?", 1).limit(8).order("created_at DESC")
    @sneakers_last_added = Sneaker.limit(8) if @sneakers_last_added.empty?
  end
  
  def newsletter 
    if Subscription.new(params[:email]).as_prospect
      redirect_to request.referer, notice: "Félicitations ! Tu vas bientôt recevoir nos offres"
    else
      redirect_to request.referer, notice: "Tu es dejà inscrit à notre newsletter !"
    end
  end

  def guide_request
    guide = Guide.find(user_params[:guide_id])
    sib_list_id = guide.fetch_sendinblue["id"]
    temp_user = User.new(user_params.except(:guide_id, :newsletter))

    if Subscription.new(temp_user).to_lc_guide(sib_list_id)
      redirect_to request.referer, notice: "Félicitations ! Tu vas bientôt recevoir ton guide par email"
    else
      redirect_to request.referer, notice: "Tu as déjà reçu ton guide !"
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :date_of_birth, :city, :guide_id, :newsletter)
  end

end
