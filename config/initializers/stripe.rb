# Set your secret key. Remember to switch to your live secret key in production.
# See your keys here: https://dashboard.stripe.com/apikeys

# Only set Stripe API key if it's configured
if Rails.application.config.stripe_secret_key.present?
  Stripe.api_key = Rails.application.config.stripe_secret_key
end