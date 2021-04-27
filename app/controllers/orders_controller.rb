class OrdersController < ApplicationController
	def create
	  sneaker = Sneaker.find(params[:sneaker_id])
	  order = Order.create!(sneaker: sneaker, sneaker_name: sneaker.name, price_cents: sneaker.price_cents, state: 'En cours', user: current_user)

		object = Stripe::Account.list({limit: 1})  
		stripe_account_id = object["data"][0]["id"]
		p "======================"
		p stripe_account_id
		p "======================"



	  payment_intent = Stripe::PaymentIntent.create({
		  payment_method_types: ['card'],
		  amount: 1000,
		  currency: 'eur',
		  transfer_data: {
		    amount: 877,
		    destination: stripe_account_id,
		  },
		})

	  # session = Stripe::Checkout::Session.create(
	  #   payment_method_types: ['card'],
	  #   line_items: [{
	  #     name: sneaker.name,
	  #     images: [sneaker.photos],
	  #     price: sneaker.price_cents,
	  #     currency: 'eur',
	  #     quantity: 1
	  #   }],
	  #   success_url: order_url(order),
	  #   cancel_url: order_url(order)
	  # )

	  # order.update(checkout_session_id: session.id)
	  # redirect_to new_order_payment_path(order)

	end
end
