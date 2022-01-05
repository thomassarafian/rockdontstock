class PaymentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:lc_complete]
  
  def lc_stripe_checkout
    lc = Authentication.new(lc_request_params)

    if lc.save
      Subscription.new(lc).as_lc_requester
    else
      redirect_to request.referer, alert: lc.errors.full_messages.join(', ')
    end

    session = Stripe::Checkout::Session.create({
      line_items: [{
        price_data: {
          currency: 'eur',
          product_data: {
            name: 'Legit Check',
          },
          unit_amount: 490,
        },
        quantity: 1,
      }],
      mode: 'payment',
      success_url: lc_payment_complete_url,
      cancel_url: 'https://example.com/cancel',
    })
    redirect_to session.url, status: 303
  end

  # def new
  #   @order = current_user.orders.where(state: 'En cours').find(params[:order_id])
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
      return status 400
    rescue Stripe::SignatureVerificationError
      return status 422
    end

    case event.type
    when 'payment_intent.payment_failed'
      # payment_intent = event.data.object
    when 'payment_intent.processing'
      # payment_intent = event.data.object
    when 'payment_intent.requires_action'
      # payment_intent = event.data.object
    when 'payment_intent.succeeded'
      # payment_intent = event.data.object
    when checkout.session.completed
      puts "*"*100, event.data.object
    when checkout.session.expired
    end

    status 200
  end

  private

  def lc_request_params
    params.require(:user).permit(:first_name, :last_name, :email, :age, :city, :photos)
  end

end