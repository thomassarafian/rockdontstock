class GuidesController < ApplicationController
  skip_before_action :authenticate_user!

  def new_request
    @guide = Guide.find(params[:id])

    respond_to do |format|
      format.js
      format.html
    end
  end
  
  def send_request    
    guide = Guide.find(params[:id])
    sib_list_id = guide.fetch_sendinblue["id"]
    temp_user = User.new(user_params.except(:newsletter))
  
    if Subscription.new(temp_user).to_lc_guide(sib_list_id)
      redirect_to request.referer, notice: "Félicitations ! Tu vas bientôt recevoir ton guide par email"
    else
      redirect_to request.referer, notice: "Tu as déjà reçu ton guide !"
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :date_of_birth, :city, :newsletter)
  end

end
