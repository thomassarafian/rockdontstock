class GuideRequestsController < ApplicationController
  skip_before_action :authenticate_user!

  def new
    @guide = Guide.find(params[:guide_id])
    @is_purchase = @guide.price_in_cents > 0 || false
    
    respond_to do |format|
      format.js
      format.html
    end
  end
  
  def create
    # guide = Guide.find(params[:id])
    # sib_list_id = guide.fetch_sendinblue["id"]

    @guide_req = GuideRequest.new(guide_req_params)

    respond_to do |format|
      if @guide_req.save
        format.js
        format.html
      else
        @message = @guide_req.errors.full_messages.join(", ")
        format.js { render status: 422 }
        format.html { render :new, status: 422, notice: @message }
      end
    end
  
    # if Subscription.new(temp_user).to_lc_guide(sib_list_id)
    #   redirect_to request.referer, notice: "Félicitations ! Tu vas bientôt recevoir ton guide par email"
    # else
    #   redirect_to request.referer, notice: "Tu as déjà reçu ton guide !"
    # end
  end

  def success
    # lc = Authentication.find(params[:id])
    # lc.update(payment_status: "paid")
    # lc.send_information_email
    redirect_to authentication_path, notice: "Merci, ta demande a bien été envoyée !"
  end

  private

  def guide_req_params
    params.require(:guide_request).permit(:first_name, :last_name, :email, :date_of_birth, :city, :newsletter, :guide_id)
  end

end