class AuthenticationsController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    lc = Authentication.new(lc_request_params)

    if lc.save
      lc.reload
      Subscription.new(lc).as_lc_requester
      render json: { lcId: lc.id }, status: 200
    else
      puts "*"*100, lc.errors.full_messages.join(', ')
      redirect_to request.referer, alert: lc.errors.full_messages.join(', ')
    end
  end

  def success
    lc = Authentication.find(params[:id])
    lc.update(payment_status: "paid")
    lc.send_information_email
    redirect_to authentication_path, notice: "Merci, ta demande a bien été envoyée !"
  end

  # def show
	# 	@lc = Authentication.find(params[:id])
  #   respond_to do |format|
  #     format.pdf { render pdf: "Récapitulatif de commande", encoding: "UTF-8" }
  #   end
  # end

  private

  def lc_request_params
    params.require(:user).permit(:first_name, :last_name, :email, :age, :city, photos: [])
  end

end
