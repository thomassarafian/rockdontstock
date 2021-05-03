class OrdersController < ApplicationController
	def show
  	@order = current_user.orders.find(params[:id])
  	authorize @order
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

		# Stripe::Token.create({
		#   account: {
		#     individual: {
		#       first_name: 'Nilsou'
		#     },
		#     tos_shown_and_accepted: true,
		#   },
		# })
		# new_token_account = Stripe::Token.create({
		# 	account: {
		#     individual: {
		#       first_name: 'Nilsou',
		#       last_name: 'Bonnavaud',
		#     },
		#     tos_shown_and_accepted: true,
		#   },
		# })


		# 	Stripe::Account.update(
		# 	  current_user.stripe_account_id,
		# 	  {
		# 	  	account_token: new_token_account,
		# 	  	individual: {
		# 	  		dob: {
		# 	  			day: 12,
		# 	  			month: 10,
		# 	  			year: 1997,
		# 	  		}
		# 	  	},
		# 		},
		# 	)
			# raise
		  # session = Stripe::Checkout::Session.create({
		  # 	customer: "cus_JOk0duXK45Jky8",
		  #   payment_method_types: ['card'],
		  #   line_items: [{
		  #   	price_data: {
		  #   		product_data: {
		  #     		name: sneaker.name,
		  #   		},
		  #   		unit_amount: order.price_cents,
		  #     	currency: "EUR",
		  #   	},
		  #   	quantity: 1,
		  #   }],
    #   	payment_intent_data: {
			 #    application_fee_amount: order.price_cents / 100, #la plateforme reçoit une commission pour le service
			 #    transfer_data: {
			 #      destination: sneaker.user.stripe_account_id,
			 #    },
			 #  },
		  #   mode: 'payment',
		  #   success_url: order_url(order),
		  #   cancel_url: order_url(order)
		  # }#,

		  # #{
		  # 	#stripe_account: current_user.stripe_account_id
		  # #}
		  # )
		  # order.update(checkout_session_id: session.id)
		  # redirect_to new_order_payment_path(order)

		  # p "==========================="
		  # p sneaker.user.stripe_account_id
		  # p session
		  # p "==========================="

	end
end
