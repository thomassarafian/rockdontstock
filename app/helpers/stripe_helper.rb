module StripeHelper
  # Stripe helper methods - Always uses test keys for demo/testing purposes
  
  # Get the Stripe public key (always test key)
  def stripe_public_key
    Rails.application.config.stripe_public_key
  end
  
  # Get the Stripe secret key (always test key)
  def stripe_secret_key
    Rails.application.config.stripe_secret_key
  end
  
  # Always in test mode for demo purposes
  def stripe_test_mode?
    true
  end
  
  # Get Stripe publishable key for JavaScript (alias for clarity)
  def stripe_publishable_key
    stripe_public_key
  end
  
  # Helper to show test mode indicator in UI
  def stripe_test_mode_indicator
    content_tag :div, "TEST MODE - No real charges", class: "stripe-test-mode-indicator" if stripe_test_mode?
  end
end
