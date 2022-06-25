class OrdersController < ApplicationController

	def new 
		@sneaker = Sneaker.find(params[:sneaker_id])
		@offer = current_user.search_accepted_offer_on(@sneaker)

		if @offer
			@price = @offer.amount
			@price_cents = @offer.amount_cents
			@initial_price = @sneaker.price
		else
			@price = @sneaker.price
			@price_cents = @sneaker.price_cents
		end
	end

	def show
		@order = Order.find(params[:id])
    respond_to do |format|
      format.pdf { render pdf: "Récapitulatif de commande", encoding: "UTF-8" }
    end
	end
	
	def create
		sneaker = Sneaker.find(order_params[:sneaker_id])
		coupon = Coupon.find_by(code: params[:order][:coupon])

		# use price of accepted offer if there is one
		if offer = current_user.search_accepted_offer_on(sneaker)
			sneaker_price = offer.amount_cents
		else
			sneaker_price = sneaker.price_cents
		end
		
		# shipping fees
		shipping_fees = { relay: 630, colissimo: 915 }
		shipping_fee = shipping_fees[order_params[:delivery].to_sym]
		
		# service fees
		# will need a better validation system if there are more
		service_fee = if coupon&.code == "FRAISOFFERTS2022"
			0
		else 
			sneaker_price * 0.06
		end

		# total price
		total_price = sneaker_price + shipping_fee + service_fee
		
		@order = Order.new(order_params.merge(
			user: current_user,
			coupon: coupon,
			shipping_fee: Money.new(shipping_fee),
			service_fee: Money.new(service_fee),
			total_price: Money.new(total_price),
		))

		@intent = Stripe::PaymentIntent.create(
			amount: total_price.to_i,
			currency: 'eur',
			automatic_payment_methods: {
				enabled: true,
			},
			metadata: {model: "Order"}
		)

		@order.payment_intent_id = @intent.id

		if @order.save
			respond_to do |format|
				format.js
				format.html
			end
		else
			redirect_to request.referer, alert: @order.errors.full_messages.join(', ')
		end
	end

	# def show
	# 	# On créé la commande 
	# 	# On envoie l'email au vendeur
	# 	# On passe la commande dans un autre state
	# 	# On passe la sneaker dans un autre state
	# 	# On retire la sneaker côté public
	# 	# Nous on va recevoir l'argent sur Stripe par exemple 220 euros. L'order elle appartient a une sneaker en particulier et la sneaker au vendeur
	# 	# @order.sneaker.user -> 
    
  #   #order = 1 donc ca veut dire que if current_user.order == 1 alors current_user.order.sneaker
  #   # if !REQUETE AJAX 
  #   	@order = current_user.orders.find(params[:id])
  #   	# current_stripe_session = retrieve_stripe_session
  #     # if current_stripe_session['payment_status'] != "paid" && @order.state == "Payé"
  #     #   capture_payment(current_stripe_session)
  #     # end

  #     # @order.update(state: "Payé") # for testing
  #     # @order.sneaker.update(state: 2) # for testing
  #     # SendcloudCreateLabel.new(@order.user, @order).create_label # for testing
      
  #     # @order_service = @order.service_cents / 2

	# 	#if @order.user.send_package == true # Si l'acheteur a envoyé le colis
	# 	#end

	# 	#if le vendeur n'a pas envoyé sa paire avant les 7 jours # Je crois que ca cancel tout seul si on a pas validé dans les 7 jours
	# 	#	cancel_payment(current_stripe_session)
	# 	#end

	# 	#if on s'apercoit que le vendeur nous a envoyé une fausse paire
	# 		# refund_payment(current_stripe_session)
	# 	#end		
	# end

	
	private
	
	def order_params
    params.require(:order).permit(:first_name, :last_name, :phone, :address, :city, :zip_code, :door_number, :delivery, :relay_address, :sneaker_id, :legal, :payment_intent_id)
	end

	# OLD CREATE
	# def create
	# if params['mondial-relay-price'].present? || params['colissimo-price'].present?
	#   @order = current_user.orders.last
	#   @sneaker = current_user.orders.last.sneaker
	#   @sneaker_db = @sneaker.sneaker_db
	#   params['mondial-relay-price'].present? ? create_stripe_session(@order, @sneaker, params['mondial-relay-price']) : create_stripe_session(@order, @sneaker, params['colissimo-price'])
	# else
	#   @sneaker = Sneaker.find(params[:sneaker_id])
	#   @sneaker_db = SneakerDb.find(@sneaker.sneaker_db_id)
	#   @order = Order.create!(sneaker: @sneaker, sneaker_name: @sneaker_db.name, price_cents: @sneaker.price_cents, state: 'En cours', user: current_user)
	#   Stripe::StripeCreateCustomer.new(current_user)
	#   redirect_to new_order_payment_path(@order)
	# end
	# end

	# def create_stripe_session(order, sneaker, deliveryPrice)
	# 	puts stripe_session = Stripe::Checkout::Session.create({
	#   	customer: current_user.customer_id,
	#     payment_method_types: ['card'],
	#     line_items: [{
	#     	price_data: {
	#     		product_data: {
	#       		name: @sneaker_db.name,
	#     			images: [@sneaker.photos[0].url],
	#     		},
	#     		unit_amount: @order.sneaker.price_cents + (deliveryPrice.to_f * 100).to_i + (@order.service_cents / 2),
	#       	currency: "EUR",
	#     	},
	#     	quantity: 1,
	#     }],
  #   	# payment_intent_data: {
  #   		# capture_method: 'manual', 
	# 	  #   application_fee_amount: order.total_price_cents / 10, #l'argent qui va au vendeur #la plateforme reçoit une commission pour le service
	# 	  #   transfer_data: {
	# 	  #     destination: sneaker.user.stripe_account_id,
	# 	    # },
	# 	  # },
  #     allow_promotion_codes: true,
	#     mode: 'payment',
	#     success_url: order_url(@order),
	#     cancel_url: root_url #new_order_payment_url(@order)
	#   })

  #   @order.checkout_session_id = stripe_session.id
  #   @order.shipping_fee_cents = (deliveryPrice.to_f * 100).to_i
  #   @order.total_price_cents = (@order.sneaker.price_cents + (deliveryPrice.to_f * 100).to_i + (@order.service_cents / 2))
  #   @order.save!

	#   # @order.update_column(:checkout_session_id, stripe_session.id)
  #   # @order.update_column(:shipping_fee_cents, (deliveryPrice.to_f * 100).to_i)
  #   # @order.update_column(:service_cents, (@order.service_cents / 2))
  #   #@order.update_column(:price_cents, (@order.sneaker.price_cents + (deliveryPrice.to_f * 100).to_i)) #+ (@order.service_cents / 2)))
	  
	# end

	# def retrieve_stripe_session
	# 	Stripe.api_key = ENV['STRIPE_SECRET']
	# 	stripe_session = Stripe::Checkout::Session.retrieve(
	# 	  @order.checkout_session_id
	# 	)
	# end

	# def capture_payment(current_stripe_session)
	# 			Stripe.api_key = ENV['STRIPE_SECRET']
	# 	Stripe::PaymentIntent.capture(
	# 	  current_stripe_session.payment_intent
	# 	)		
	# end

	# def cancel_payment(current_stripe_session)
	# 			Stripe.api_key = ENV['STRIPE_SECRET']
	# 	Stripe::PaymentIntent.cancel(
 #  		current_stripe_session.payment_intent
	# 	)
	# end

	# def refund_payment(current_stripe_session)
	# 			Stripe.api_key = ENV['STRIPE_SECRET']

	# 	Stripe::Refund.create({
	# 		payment_intent: current_stripe_session.payment_intent,
	# 	})
	# end
end
