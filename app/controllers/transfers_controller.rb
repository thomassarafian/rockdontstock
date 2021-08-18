class TransfersController < ApplicationController
    skip_after_action :verify_authorized, only: [:index, :create]
	 
  def index
		skip_policy_scope
    @user = current_user
		
    @account = Stripe::Account.retrieve(@user.stripe_account_id)

		@balance = Stripe::Balance.retrieve({stripe_account: @user.stripe_account_id})


		# POUR CREER UNE LIEN AVEC SA BANQUE AFIN DE FAIRE DES VIREMENTS 
		
		# FAIRE LES VIREMENTS A PROPREMENT PARLÉ
		# p payout = Stripe::Payout.create({
		#   amount: 100,
		#   currency: 'eur',
		#   destination: @account.external_accounts.data[0].id,#'ba_1Inmn42QFklsr9vGI323QckG',@account.external_accounts.data[0].id
		#   source_type: 'bank_account',
		#   method: "standard",
		# 	}, {
		# 		stripe_account: @user.stripe_account_id, #'acct_1InK1r2QFklsr9vG',
		# 	})
		

	end

	def create
    if params['file-front-hid'].present? && params['file-back-hid'].present? && params['file-home-hid'].present?
      token = Stripe::Token.create({
        account: {
          individual: {
            verification: {
              document: {
                front: params['file-front-hid'],
                back: params['file-back-hid'],
              },
              additional_document: {
                front: params['file-home-hid']
              }
            },
          },
          tos_shown_and_accepted: true,
        },
      })
      begin
        Stripe::Account.update(
          current_user.stripe_account_id,
          {
            account_token: token
          });
        redirect_to user_transfers_path, notice: "Tes documents viennent d'être envoyés"
      rescue Exception => e
        redirect_to user_transfers_path, notice: "Impossible d'envoyer tes documents"
      end
    elsif params['send-money-bank'] == '1'
      @user = current_user
      @account = Stripe::Account.retrieve(@user.stripe_account_id)
      @balance = Stripe::Balance.retrieve({stripe_account: @user.stripe_account_id})

      payout = Stripe::Payout.create({
        amount: @balance.available[0].amount,
        currency: 'eur',
        destination: @account.external_accounts.data[0].id,
        method: "standard",
        },{
          stripe_account: @user.stripe_account_id,
      })
      redirect_to user_transfers_path, notice: "Le virement vient d'être effectué !"
    end
  end

  private

  def transfer_params
    params.require(:transfer).permit(:iban)
  end


end


























#Creer un virement vers le compte du vendeur : 
# transfer = Stripe::Transfer.create({
#   amount: 1000 , # sneaker.price - 490 (livraison) - (12 % du prix de la paire / 2) (service)
#   currency: "eur",
#   destination: "acct_1Iuvaq2RPNtnbUTH",
# }) 



# # Je sais pas 
# p payout = Stripe::Payout.create({
#       amount: 100,
#       currency: 'eur',
#       destination: 'ba_1Inmn42QFklsr9vGI323QckG',#@account.external_accounts.data[0].id
#       method: "standard",
#       }, {
#         stripe_account: 'acct_1InK1r2QFklsr9vG',
#       }) 



 
# if current_user
#   if !current_user.token_account? && current_user.date_of_birth? && current_user.line1? && current_user.city? && current_user.postal_code? && current_user.phone? 
#     create_connect_account
#     p "LE USER A REMPLI TOUTE SES INFOS DONC ON LUI CRÉÉ UN COMPTE CONNECT"
#   end 
#   #if current_user.ids[0] && current_user.ids[1] && current_user.ids[2]
#     #send_identity_document
#   #end 
# end




# def send_identity_document
#   identity_front = Stripe::File.create({
#     purpose: 'identity_document',
#     file: File.new(current_user.ids[0].current_path),
#     }, {
#     stripe_account: current_user.stripe_account_id,
#   })

#   identity_verso = Stripe::File.create({
#     purpose: 'identity_document',
#     file: File.new(current_user.ids[1].current_path),
#     }, {
#     stripe_account: current_user.stripe_account_id,
#   })

#   identity_address = Stripe::File.create({
#     purpose: 'identity_document',
#     file: File.new(current_user.ids[2].current_path),
#     }, {
#     stripe_account: current_user.stripe_account_id,
#   })

#   person_token = Stripe::Token.create({
#     person: {
#     verification: {
#       document: {
#           front: identity_front.id,
#               back: identity_verso.id,
#       },
#       additional_document: {
#         front: identity_address.id
#       }
#     },
#     },
#   })

#   Stripe::Account.update_person(
#     current_user.stripe_account_id,
#     current_user.person_id,
#     {
#       person_token: person_token
#     })    
# end


# identity_address = Stripe::File.create({
#   purpose: 'identity_document',
#   file: File.new(current_user.ids[2].current_path),
#   }, {
#   stripe_account: 'acct_1InK1r2QFklsr9vG',
# })


# identity_front = Stripe::File.create({
#   purpose: 'identity_document',
#   file: File.new(current_user.ids[0].current_path),
#   }, {
#   stripe_account: 'acct_1InK1r2QFklsr9vG',
# })

# identity_verso = Stripe::File.create({
#   purpose: 'identity_document',
#   file: File.new(current_user.ids[1].current_path),
#   }, {
#   stripe_account: 'acct_1InK1r2QFklsr9vG',
# })

# person_token = Stripe::Token.create({
#   person: {
#   verification: {
#     document: {
#         front: identity_front.id,
#             back: identity_verso.id,
#     },
#     additional_document: {
#       front: identity_address.id
#     }
#   },
#   },
# })

# Stripe::Account.update_person(
#   'acct_1InK1r2QFklsr9vG',
#   'person_4InK1r00pgBlEfDf',
#   {
#     person_token: person_token
#   })





