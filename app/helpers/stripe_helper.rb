module StripeHelper
  # Get the appropriate Stripe public key based on environment
  def stripe_public_key
    Rails.application.config.stripe_public_key
  end
  
  # Get the appropriate Stripe secret key based on environment
  def stripe_secret_key
    Rails.application.config.stripe_secret_key
  end
  
  # Check if we're using test mode
  def stripe_test_mode?
    !Rails.env.production?
  end
  
  # Get Stripe publishable key for JavaScript (alias for clarity)
  def stripe_publishable_key
    stripe_public_key
  end
end
