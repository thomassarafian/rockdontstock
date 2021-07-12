module Stripe
  class StripeCreateConnectAccount
    def initialize(user)
      # if attributes_are_filled?(user)
      # raise
        create_connect_account(user)
      # end
    end
    
    private
    def create_connect_account(user)
      create_token = stripe_create_token(user)
      user.update_column(:token_account, create_token.id)

      stripe_account = Stripe::Account.create({
        account_token: user.token_account,
        type: 'custom',
        business_profile: {
          mcc: 5691,
          url: "rockdontstock.com",
        },
        country: 'FR',
        email: user.email,
        capabilities: {
          card_payments: {requested: true},
          transfers: {requested: true},
        }
      })
      user.update_column(:stripe_account_id, stripe_account.id)
      user.update_column(:person_id, stripe_account['individual'].id)
    end

    def stripe_create_token(user)
      return Stripe::Token.create({
        account: {
          business_type: "individual",
          individual: {
            email: user.email,
            first_name: user.first_name,
            last_name: user.last_name,
            phone: user.phone,
            address: {
              line1: user.line1,
              city: user.city,
              postal_code: user.postal_code,
            },
            dob: {
              day: user.date_of_birth.day,
              month: user.date_of_birth.month,
              year: user.date_of_birth.year,
            }
          },
          tos_shown_and_accepted: true,
        },
      })
    end
  end
end