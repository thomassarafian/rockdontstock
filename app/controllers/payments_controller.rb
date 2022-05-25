class PaymentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:stripe_webhooks]
  
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
end