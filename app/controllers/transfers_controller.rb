class TransfersController < ApplicationController
	def index
		skip_policy_scope
		@account = Stripe::Account.retrieve('acct_1InK1r2QFklsr9vG')
		# @bank_account = Stripe::Account.create_external_account(
		# 	'acct_1InK1r2QFklsr9vG',
		# 	{
		#   	external_account: {
		#   		object: 'bank_account',
		#   		country: 'FR',
		#   		currency: 'eur',
		#   		account_holder_name: 'Nouveau tout propre',
		#   		account_holder_type: 'individual',
		#   		account_number: 'FR1420041010050500013M02606'
		#   	},
		# 	},
		# )

		# raise
		payout = Stripe::Payout.create({
		  amount: 100,
		  currency: 'eur',
		  destination: 'ba_1Inmn42QFklsr9vGI323QckG',#@account.external_accounts.data[0].id
		  source_type: 'bank_account',
		  method: "standard",
			}, {
				stripe_account: 'acct_1InK1r2QFklsr9vG',
			})
		# payout = Stripe::Payout.create({
		#   amount: 1000,
		#   currency: 'eur',
		#   method: 'instant',
		# }, {
		#   stripe_account: 'acct_1InK1r2QFklsr9vG',
		# })
	end

	# def new
	# end

	private
end
