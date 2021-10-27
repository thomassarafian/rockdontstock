module Stripe
  class StripeSendIban
    
  def initialize(user, iban)
    @user = user
    @iban = iban
  end

  def call
    begin
      puts @bank_account = Stripe::Account.create_external_account(
        @user.stripe_account_id,
        {
          external_account: {
            object: 'bank_account',
            country: 'FR',
            currency: 'eur',
            account_holder_name: @user.first_name + " " +  @user.last_name,
            account_holder_type: 'individual',
            account_number: @iban,
          },
        },
      )
    rescue Exception => e
      puts e 
    end
  end

  private
  attr_reader :user, :iban

  end
end
