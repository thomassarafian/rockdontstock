require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Rockdontstock
  class Application < Rails::Application
    config.generators do |generate|
      generate.assets false
      generate.helper false
      generate.test_framework :test_unit, fixture: false
    end
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1
    config.filter_parameters += [:password, :stripe_account_id] #for FILTERED PARAMS
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = "Paris"
    # config.eager_load_paths << Rails.root.join("extras")


    config.i18n.default_locale = :fr
    
    # Stripe configuration - Always use test keys for demo/testing purposes
    config.stripe_secret_key = ENV['STRIPE_SECRET_TEST']
    config.stripe_public_key = ENV['STRIPE_PUBLIC_TEST']
    
    null_regex = Regexp.new(/\Anull\z/)
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        hostnames = [null_regex, 'localhost:4200', 'app.forestadmin.com', 'localhost:3000']
        # Add additional CORS origins from environment variable if provided
        if ENV['CORS_ORIGINS'].present?
          hostnames += ENV['CORS_ORIGINS'].split(',').map(&:strip).reject(&:blank?)
        end
        origins hostnames
        resource '*',
          headers: :any,
          methods: :any,
          expose: ['Content-Disposition'],
          credentials: true
      end
    end
  end
end
