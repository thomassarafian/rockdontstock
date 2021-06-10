class OrdersController < ApplicationController
	def show
		# On créé la commande 
		# On envoie l'email au vendeur
		# On passe la commande dans un autre state
		# On passe la sneaker dans un autre state
		# On retire la sneaker côté public
		# Nous on va recevoir l'argent sur Stripe par exemple 220 euros. L'order elle appartient a une sneaker en particulier et la sneaker au vendeur
		# @order.sneaker.user -> 
    
    #order = 1 donc ca veut dire que if current_user.order == 1 alors current_user.order.sneaker
  	@order = current_user.orders.find(params[:id])
  	authorize @order
    @order.update(state: "Payé")
  	current_stripe_session = retrieve_stripe_session

		# SendcloudCreateLabel.new(current_user, @order).create_label


		#if @order.user.send_package == true # Si l'acheteur a envoyé le colis
			# capture_payment(current_stripe_session)
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
		if !current_user.customer_id?
			create_stripe_customer
		end
		create_stripe_session(order, sneaker)
	end

	private


	def create_stripe_customer
		customer = Stripe::Customer.create({
			name: current_user.first_name + " " + current_user.last_name,
			email: current_user.email
		})
		current_user.update(customer_id: customer.id)
	end


	def create_stripe_session(order, sneaker)
		Stripe.api_key = ENV['STRIPE_SECRET_TEST']

		stripe_session = Stripe::Checkout::Session.create({
	  	customer: current_user.customer_id,
	    payment_method_types: ['card'],
	    line_items: [{
	    	price_data: {
	    		product_data: {
	      		name: sneaker.name,
	    			images: [sneaker.photos[0].url],
	    		},
	    		unit_amount: order.price_cents + order.shipping_cost_cents + order.insurance_cents + (order.service_cents / 2),
	      	currency: "EUR",
	    	},
	    	quantity: 1,
	    }],
    # 	payment_intent_data: {
    # 		capture_method: 'manual', 
		  #   application_fee_amount: order.price_cents / 10, #l'argent qui va au vendeur #la plateforme reçoit une commission pour le service
		  #   transfer_data: {
		  #     destination: sneaker.user.stripe_account_id,
		  #   },
		  # },
	    mode: 'payment',
	    success_url: order_url(order),
	    cancel_url: sneaker_url(sneaker)
	  })
	  order.update(checkout_session_id: stripe_session.id)
	  redirect_to new_order_payment_path(order)
	end

	def retrieve_stripe_session
		Stripe.api_key = ENV['STRIPE_SECRET_TEST']
		stripe_session = Stripe::Checkout::Session.retrieve(
		  @order.checkout_session_id
		)
	end

	def capture_payment(current_stripe_session)
				Stripe.api_key = ENV['STRIPE_SECRET_TEST']
		Stripe::PaymentIntent.capture(
		  current_stripe_session.payment_intent
		)		
	end

	def cancel_payment(current_stripe_session)
				Stripe.api_key = ENV['STRIPE_SECRET_TEST']
		Stripe::PaymentIntent.cancel(
  		current_stripe_session.payment_intent
		)
	end

	def refund_payment(current_stripe_session)
				Stripe.api_key = ENV['STRIPE_SECRET_TEST']

		Stripe::Refund.create({
			payment_intent: current_stripe_session.payment_intent,
		})
	end
end
