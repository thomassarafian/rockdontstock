class User < ApplicationRecord
  validates :first_name, :last_name, presence: true
  has_many :sneakers
  has_many :orders

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable
	devise :database_authenticatable, :registerable,
    	:recoverable, :rememberable, :validatable
  devise :omniauthable, omniauth_providers: [:facebook, :google_oauth2]
  
  has_many_attached :ids
  

  # after_create :send_notification # a configurer avec mailjet 
  after_update :create_connect_account, if: :attributes_are_filled?
  
  def attributes_are_filled?
    if current_user
      if current_user.email? && current_user.first_name? && current_user.last_name? && current_user.phone? && current_user.line1? && current_user.city? \
        && current_user.postal_code? && current_user.date_of_birth.day? && current_user.date_of_birth.month? && current_user.date_of_birth.year?
        return true
      else
        false
      end
    end
  end

  def create_connect_account
    stripe_create_token

    current_user.update(token_account: stripe_create_token.id)
    
    stripe_account = Stripe::Account.create({
      account_token: current_user.token_account,
      type: 'custom',
      business_profile: {
        mcc: 5691,
        url: "rockdontstock.com",
      },
      country: 'FR',
      email: current_user.email,
      capabilities: {
        card_payments: {requested: true},
        transfers: {requested: true},
      }
    })
    current_user.update(stripe_account_id: stripe_account.id)
    current_user.update(person_id: stripe_account['individual'].id)
  end

  def stripe_create_token
    Stripe::Token.create({
    account: {
      business_type: "individual",
      individual: {
        email: current_user.email,
        first_name: current_user.first_name,
        last_name: current_user.last_name,
        phone: "+33606060606",
        address: {
          line1: current_user.line1,
          city: current_user.city,
          postal_code: current_user.postal_code,
        },
        dob: {
          day: current_user.date_of_birth.day,
          month: current_user.date_of_birth.month,
          year: current_user.date_of_birth.year,
        }

      },
      tos_shown_and_accepted: true,
    },
  })
  end









  def send_notification
    UserMailer.new_user(self).deliver
  end

    
  def self.create_from_google_data(auth)
    user_params = auth.slice("provider", "uid")
    user_params.merge! auth.info.slice("email", "first_name", "last_name")
    user_params[:picture_url] = auth.info.image
    user_params[:token] = auth.credentials.token
    user_params[:token_expiry] = Time.at(auth.credentials.expires_at)
    user_params = user_params.to_h

    user = User.find_by(provider: auth.provider, uid: auth.uid)
    user ||= User.find_by(email: auth.info.email) # User did a regular sign up in the past.
    if user
      user.update(user_params)
    else
      user = User.new(user_params)
      user.password = Devise.friendly_token[0,20]  # Fake password for validation
      user.save
    end
    return user
  end

   def self.find_for_facebook_oauth(auth)
    user_params = auth.slice("provider", "uid")
    user_params.merge! auth.info.slice("email", "first_name", "last_name")
    user_params[:picture_url] = auth.info.image
    user_params[:token] = auth.credentials.token
    user_params[:token_expiry] = Time.at(auth.credentials.expires_at)
    user_params = user_params.to_h

    user = User.find_by(provider: auth.provider, uid: auth.uid)
    user ||= User.find_by(email: auth.info.email) # User did a regular sign up in the past.
    if user
      user.update(user_params)
    else
      user = User.new(user_params)
      user.password = Devise.friendly_token[0,20]  # Fake password for validation
      user.save
    end
    return user
  end

end
