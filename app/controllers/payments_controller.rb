class PaymentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:lc_complete, :lc_stripe_checkout, :stripe_webhooks]
  
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
      metadata: { lc_id: lc.id },
      success_url: lc_payment_complete_url,
      cancel_url: 'https://example.com/cancel',
    })
    redirect_to session.url, status: 303
  end
  
  def sneaker_stripe_checkout
    order = Order.new(order_params.merge(user: current_user))

    if order.save
      shipping_fees = { relay: 6.30, colissimo: 9.15 }

      # price of sneaker + shipping + 6% of sneaker price
      total_price = 1.06 * order.sneaker.price + shipping_fees[params[:delivery]]

      session = Stripe::Checkout::Session.create({
        line_items: [{
          price_data: {
            currency: 'eur',
            product_data: {
              name: order.sneaker.sneaker_db.name,
              images: [order.sneaker.photos.first.url]
            },
            unit_amount: total_price * 100,
          },
          quantity: 1,
        }],
        mode: 'payment',
        metadata: { order_id: order.id },
        success_url: sneaker_payment_complete_url + "?session_id={CHECKOUT_SESSION_ID}",
        cancel_url: 'https://example.com/cancel',
      })
      redirect_to session.url, status: 303
    else
      redirect_to request.referer, alert: order.errors.full_messages.join(', ')
    end

  end

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
    when 'payment_intent.succeeded'

    when 'checkout.session.completed'
      checkout = event.data.object

      if lc_id = checkout.metadata.lc_id
        lc = Authentication.find(lc_id)
        lc.update(payment_status: "paid")
        
      elsif order_id = checkout.metadata.order_id
        order = Order.find(order_id)
        order.update(payment_status: "paid")
      end
    end

    status 200
  end

  def sneaker_complete
    session = Stripe::Checkout::Session.retrieve(params[:session_id])
    customer = Stripe::Customer.retrieve(session.customer)
    puts "*"*100, session
    puts "!"*100, customer
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

  private

  def lc_request_params
    params.require(:user).permit(:first_name, :last_name, :email, :age, :city, :photos)
  end

  def order_params
    params.require(:order).permit(:first_name, :last_name, :phone, :address, :city, :zip_code, :door_number, :delivery, :sneaker_id)
  end

end