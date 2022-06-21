class PaymentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:stripe_webhooks, :create_payment_intent]
  
  def sneaker_complete
    # here we only want proper display informations, the actual update
    # of payment status and payment method happens through webhooks
  
    @order = Order.find(params[:order_id])
    intent = Stripe::PaymentIntent.retrieve(params[:payment_intent])
    @payment_method = intent.payment_method_types[0]
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
      payment_intent = event.data.object
      model = payment_intent.metadata.model.constantize
  
      record = model.find_by(payment_intent_id: payment_intent.id)
      args = {
        payment_method: payment_intent["payment_method_types"][0],
        payment_status: "paid"
      }

      # old system, needed to trigger before_update callbacks
      # to be removed eventually to avoid duplicated infos
      args[:state] = "Payé" if model == "Order"

      record.update(args)
    end
  
    head :ok
  end

  def create_payment_intent
    model = params['model'].constantize
    @record = model.find(params['id'])
    amount = record.price_in_cents

    check_coupon_validity if model == Authentication

    payment_intent = Stripe::PaymentIntent.create(
      amount: amount,
      currency: 'eur',
      automatic_payment_methods: {
        enabled: true,
      },
      metadata: {model: params['model']}
    )

    record.update(payment_intent_id: payment_intent.id)

    render json: {clientSecret: payment_intent['client_secret']}
  end

  private

  def check_coupon_validity
    return if !@record.coupon

    # TODO
    if Stripe::Coupon.retrieve(@record.coupon)
      # apply discount
    else
      # price doesnt change
    end
  end
end