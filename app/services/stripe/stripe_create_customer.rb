module Stripe
  class StripeCreateCustomer
    def initialize(user)
      if !user.customer_id?
        create_stripe_customer(user)
      end
    end
  
  private

    def create_stripe_customer(user)
      customer = Stripe::Customer.create({
        name: user.first_name + " " + user.last_name,
        email: user.email
      })
      user.update(customer_id: customer.id)
    end
  end
end
