# Set your secret key. Remember to switch to your live secret key in production.
# See your keys here: https://dashboard.stripe.com/apikeys

Rails.configuration.stripe = {
	signing_secret: ENV["STRIPE_WEBHOOK_SECRET"]
}

Stripe.api_key = ENV["STRIPE_SECRET"]

StripeEvent.signing_secret = Rails.configuration.stripe[:signing_secret]

StripeEvent.configure do |events|
  events.subscribe 'checkout.session.completed', StripeCheckoutSessionService.new
end