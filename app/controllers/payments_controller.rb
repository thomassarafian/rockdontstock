class PaymentsController < ApplicationController
  def new
    @order = current_user.orders.where(state: 'En cours').find(params[:order_id])
    authorize @order
    @auth = {
      username: ENV["SENDCLOUD_API_KEY"],
      password: ENV["SENDCLOUD_SECRET_KEY"]
    }
    get_shipping_price_ml = HTTParty.get(
     "https://panel.sendcloud.sc/api/v2/shipping-price/?shipping_method_id=#{1680}&from_country=FR&to_country=FR&weight=2&weight_unit=kilogram",
     :headers => { 'Content-Type' => 'application/json' },
     basic_auth: @auth)

    get_shipping_price_colissimo = HTTParty.get(
     "https://panel.sendcloud.sc/api/v2/shipping-price/?shipping_method_id=#{1066}&from_country=FR&to_country=FR&weight=2&weight_unit=kilogram",
     :headers => { 'Content-Type' => 'application/json' },
     basic_auth: @auth)
    
    # get_shipping_price_chronopost = HTTParty.get(
    #  "https://panel.sendcloud.sc/api/v2/shipping-price/?shipping_method_id=#{1346}&from_country=FR&to_country=FR&weight=2&weight_unit=kilogram",
    #  :headers => { 'Content-Type' => 'application/json' },
    #  basic_auth: @auth)
    
    @mondial_relay_price = (get_shipping_price_ml['price'].to_f * 1.2).truncate(2)
    @colissimo_price = (get_shipping_price_colissimo['price'].to_f * 1.2).truncate(2)
    # @chronopost_price = (get_shipping_price_chronopost['price'].to_f * 1.2).truncate(2)
  end	
end