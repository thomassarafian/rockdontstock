class AuthenticationsController < ApplicationController

  def create
    lc = Authentication.new(lc_request_params)

    if lc.save
      Subscription.new(lc).as_lc_requester
      redirect_to stripe_checkout_path, method: :post
    else
      redirect_to request.referer, alert: lc.errors.full_messages.join(', ')
    end
  end

  private

  def lc_request_params
    params.require(:user).permit(:first_name, :last_name, :email, :age, :city, :photos)
  end

end
