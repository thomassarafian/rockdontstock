class AuthenticationsController < ApplicationController
  skip_before_action :authenticate_user!

  def new
    @product = Product.find(params[:product_id])

    respond_to do |format|
      format.js
      format.html
    end
  end

  def create
    photos = (params[:photos].present? && params[:photos].values) || nil
    @lc = Authentication.new(lc_params.merge(photos: photos))

    if @lc.save
      render json: { lcId: @lc.id }, status: 200
    else
      render json: { message: @lc.errors.full_messages.join(", ") }, status: 422
    end
  end

  def success
    # lc = Authentication.find(params[:id])
    # lc.update(payment_status: "paid")
    # lc.send_information_email
    redirect_to authentication_path, notice: "Merci, ta demande a bien été envoyée !"
  end

  # def show
	# 	@lc = Authentication.find(params[:id])
  #   respond_to do |format|
  #     format.pdf { render pdf: "Récapitulatif de commande", encoding: "UTF-8" }
  #   end
  # end

  private

  def lc_params
    params.require(:authentication).permit(:first_name, :last_name, :email, :date_of_birth, :city, :newsletter, :product_id)
  end

end
