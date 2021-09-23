class StripeCheckoutSessionService
  def call(event)
    order = Order.find_by(checkout_session_id: event.data.object.id)
    order.sneaker.update(state: 2)
    order.update(state: 'Payé')
  end
end
