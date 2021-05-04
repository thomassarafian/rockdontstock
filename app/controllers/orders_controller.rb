class OrdersController < ApplicationController
	def show
  	@order = current_user.orders.find(params[:id])
  	authorize @order
  	current_stripe_session = retrieve_stripe_session
		#if @order.user.send_package == true # Si l'acheteur a envoyé le colis
			capture_payment(current_stripe_session)
		#end

		#if le vendeur n'a pas envoyé sa paire avant les 7 jours # Je crois que ca cancel tout seul si on a pas validé dans les 7 jours
		#	cancel_payment(current_stripe_session)
		#end

		#if on s'apercoit que le vendeur nous a envoyé une fausse paire
			# refund_payment(current_stripe_session)
		#end		
	end

	def create
	  sneaker = Sneaker.find(params[:sneaker_id])
	  order = Order.create!(sneaker: sneaker, sneaker_name: sneaker.name, price_cents: sneaker.price_cents, state: 'En cours', user: current_user)
	  authorize order
		create_stripe_session(order, sneaker)
	end

	private

	def create_stripe_session(order, sneaker)
		stripe_session = Stripe::Checkout::Session.create({
	  	customer: "cus_JPmgmod0EE3LXW",
	    payment_method_types: ['card'],
	    line_items: [{
	    	price_data: {
	    		product_data: {
	      		name: sneaker.name,
	    		},
	    		unit_amount: order.price_cents,
	      	currency: "EUR",
	    	},
	    	quantity: 1,
	    }],
    	payment_intent_data: {
    		capture_method: 'manual', 
		    application_fee_amount: order.price_cents - 500, #l'argent qui va au vendeur #la plateforme reçoit une commission pour le service
		    transfer_data: {
		      destination: "acct_1InK1r2QFklsr9vG", #sneaker.user.stripe_account_id,
		    },
		  },
	    mode: 'payment',
	    success_url: order_url(order),
	    cancel_url: sneaker_url(sneaker)
	  })

	  order.update(checkout_session_id: stripe_session.id)
	  redirect_to new_order_payment_path(order)
	end

	def retrieve_stripe_session
		stripe_session = Stripe::Checkout::Session.retrieve(
		  @order.checkout_session_id
		)
	end

	def capture_payment(current_stripe_session)
		Stripe::PaymentIntent.capture(
		  current_stripe_session.payment_intent
		)		
	end

	def cancel_payment(current_stripe_session)
		Stripe::PaymentIntent.cancel(
  		current_stripe_session.payment_intent
		)
	end

	def refund_payment(current_stripe_session)
		Stripe::Refund.create({
			payment_intent: current_stripe_session.payment_intent,
		})
	end
end
