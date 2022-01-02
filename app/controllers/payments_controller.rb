class PaymentsController < ApplicationController
  skip_after_action :verify_authorized

  def complete
  end

  # def new
  #   @order = current_user.orders.where(state: 'En cours').find(params[:order_id])
  #   authorize @order
  #   @auth = {
  #     username: ENV["SENDCLOUD_API_KEY"],
  #     password: ENV["SENDCLOUD_SECRET_KEY"]
  #   }
  #   get_shipping_price_ml = HTTParty.get(
  #    "https://panel.sendcloud.sc/api/v2/shipping-price/?shipping_method_id=#{1680}&from_country=FR&to_country=FR&weight=2&weight_unit=kilogram",
  #    :headers => { 'Content-Type' => 'application/json' },
  #    basic_auth: @auth)

  #   get_shipping_price_colissimo = HTTParty.get(
  #    "https://panel.sendcloud.sc/api/v2/shipping-price/?shipping_method_id=#{1066}&from_country=FR&to_country=FR&weight=2&weight_unit=kilogram",
  #    :headers => { 'Content-Type' => 'application/json' },
  #    basic_auth: @auth)
    
  #   # get_shipping_price_chronopost = HTTParty.get(
  #   #  "https://panel.sendcloud.sc/api/v2/shipping-price/?shipping_method_id=#{1346}&from_country=FR&to_country=FR&weight=2&weight_unit=kilogram",
  #   #  :headers => { 'Content-Type' => 'application/json' },
  #   #  basic_auth: @auth)
    
  #   @mondial_relay_price = get_shipping_price_ml[0]['price'] #.to_f * 1.2).truncate(2) #6.30
  #   @colissimo_price = get_shipping_price_colissimo[0]['price'] #.to_f * 1.2).truncate(2) #9.15
  #   # @chronopost_price = (get_shipping_price_chronopost['price'].to_f * 1.2).truncate(2)
  # end

  def stripe_webhooks
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = ENV['STRIPE_WEBHOOK_SECRET']
    event = nil

    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
    rescue JSON::ParserError
      return head :bad_request
    rescue Stripe::SignatureVerificationError
      return head :unauthorized
    end

    case event.type
    when 'payment_intent.payment_failed'
      payment_intent = event.data.object
    when 'payment_intent.processing'
      payment_intent = event.data.object
    when 'payment_intent.requires_action'
      payment_intent = event.data.object
    when 'payment_intent.succeeded'
      payment_intent = event.data.object
    end

    head :ok
  end
end