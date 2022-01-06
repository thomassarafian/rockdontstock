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
      customer_email: lc.email,
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
      shipping_fees = { relay: 630, colissimo: 915 }

      @shipping_fee = shipping_fees[order_params[:delivery].to_sym]
      @service_fee = order.sneaker.price_cents * 0.06
      @total_price = order.sneaker.price_cents + @shipping_fee + @service_fee

      session = Stripe::Checkout::Session.create({
        customer_email: order.user.email,
        line_items: [{
          price_data: {
            currency: 'eur',
            product_data: {
              name: order.sneaker.sneaker_db.name,
              images: [order.sneaker.photos.first.url]
            },
            unit_amount: @total_price.to_i,
          },
          quantity: 1,
        }],
        mode: 'payment',
        metadata: { order_id: order.id, shipping_fee: @shipping_fee, service_fee: @service_fee, total_price: @total_price },
        success_url: sneaker_payment_complete_url + "?session_id={CHECKOUT_SESSION_ID}&shipping_fee=#{@shipping_fee}&service_fee=#{@service_fee}&total_price=#{@total_price}",
        cancel_url: 'https://example.com/cancel',
      })
      redirect_to session.url, status: 303
    else
      redirect_to request.referer, alert: order.errors.full_messages.join(', ')
    end

  end
  
  def sneaker_complete
    # here we only want proper display informations,
    # the update of the order happens in webhooks
    session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @order = Order.find(session.metadata.order_id)
    @payment_method = session.payment_method_types[0]
    @shipping_fee = Money.new(params[:shipping_fee])
    @service_fee = Money.new(params[:service_fee])
    @total_price = Money.new(params[:total_price])
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
    when 'checkout.session.completed'
      checkout = event.data.object
      puts "*"*100
      puts checkout
      puts checkout.metadata
      puts checkout.metadata.order_id
      puts checkout.metadata["order_id"]
      puts checkout["metadata"]["order_id"]
      puts "*"*100

      if checkout.metadata["lc_id"]
        lc_id = checkout.metadata["lc_id"]
        lc = Authentication.find(lc_id)
        lc.update(
          checkout_session_id: checkout.id,
          payment_method: checkout["payment_method_types"][0],
          payment_status: "paid"
        )
      elsif checkout.metadata["order_id"]
        order_id = checkout.metadata["order_id"]
        order = Order.find(order_id)
        order.update(
          checkout_session_id: checkout.id,
          payment_method: checkout["payment_method_types"][0],
          payment_status: "paid",
          shipping_fee: checkout.metadata["shipping_fee"],
          service_fee: checkout.metadata["service_fee"],
          total_price: checkout.metadata["total_price"]
        )
      end
    end

    render status: 200
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
    params.require(:order).permit(:first_name, :last_name, :phone, :address, :city, :zip_code, :door_number, :delivery, :relay_address, :sneaker_id, :legal)
  end

end