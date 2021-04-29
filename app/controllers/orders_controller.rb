class OrdersController < ApplicationController
	def show
  	@order = current_user.orders.find(params[:id])
	end

	def create
	  sneaker = Sneaker.find(params[:sneaker_id])
	  order = Order.create!(sneaker: sneaker, sneaker_name: sneaker.name, price_cents: sneaker.price_cents, state: 'En cours', user: current_user)
	  authorize order
		# object = Stripe::Account.list({limit: 1})  
		# stripe_account_id = object["data"][0]["id"]
		# p "======================"
		# p stripe_account_id
		# p "======================"
		# p current_user.stripe_account_id
		# p "======================"
	 #  payment_intent = Stripe::PaymentIntent.create({
		#   payment_method_types: ['card'],
		#   amount: 1000,
		#   currency: 'eur',
		#   transfer_data: {
		#     amount: 877,
		#     destination: stripe_account_id,
		#   },
		# })


		  session = Stripe::Checkout::Session.create({
		    payment_method_types: ['card'],
		    line_items: [{
		    	price_data: {
		    		product_data: {
		      		name: sneaker.name,
		    		},
		    		unit_amount: 1000,
		      	currency: "EUR",
		    	},
		    	quantity: 1,
		    }],
		    mode: 'payment',
		    success_url: order_url(order),
		    cancel_url: order_url(order)
		  }, {
		  	stripe_account: current_user.stripe_account_id
		  })
		  order.update(checkout_session_id: session.id)
		  redirect_to new_order_payment_path(order)



	end
end
