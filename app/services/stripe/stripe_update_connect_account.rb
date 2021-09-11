module Stripe
  class StripeUpdateConnectAccount
    def initialize(user)
      update_connect_account(user)
    end
    
    private
    def update_connect_account(user)
      stripe_account = Stripe::Account.update(
        user.stripe_account_id, {
          account_token: user.token_account,
        }
      )
    end
  end
end