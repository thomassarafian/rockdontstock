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
  
  validate :correct_ids_type?

  # after_create :send_notification # a configurer avec mailjet 
  
  after_update :create_connect_account, if: :attributes_are_filled?

  # after_update :send_ids, if: :ids_are_filled?
  

  #le but c'est de creer les documents
  private
    def correct_ids_type?
      user = self
      if user.ids[0].present? && user.ids[1].present? && user.ids[2].present?
        unless user.ids[0].content_type.in?(%w(image/jpg image/png image/pdf))
          errors.add(:ids, "Les fichiers doivent etre du type JPG, PNG ou PDF")
        end
      end
    end

    def ids_are_filled?
    # LISTE DES CAS
    # si le gars rempli ses infos pour la 1ere fois
    # si le gars avait deja send mais qu'il veut re-send
    # si le gars veut update des infos mais pas modifier ça
    # si le gars a deja rempli ses infos mais qu'il veut juste modifier son prénom alors il passera dedans et il resendera

      user = self
      if user.ids[0].present? && user.ids[1].present? && user.ids[2].present? 
        p "User IDs OK "
        p "User IDs OK "
        p "User IDs OK "
        p "User IDs OK "
        p "User IDs OK "
        p "User IDs OK "

        return true
      else
        return false
      end
    end
    
    def send_ids
      user = self
      identity_front = retrieve_front_id(user)
      identity_verso = retrieve_verso_id(user)
      proof_of_address = retrieve_proof_of_address(user)
      person_token = create_person_token(identity_front, identity_verso, proof_of_address)
      update_person(user, person_token)
    end

    def retrieve_front_id(user)
      return Stripe::File.create({
        purpose: 'identity_document',
        file: File.new(user.ids[0].url),
        }, {
        stripe_account: user.stripe_account_id,
      })
    end

    def retrieve_verso_id(user)
      return Stripe::File.create({
        purpose: 'identity_document',
        file: File.new(user.ids[1].url),
        }, {
        stripe_account: user.stripe_account_id,
      })
    end

    def retrieve_proof_of_address(user)
      return Stripe::File.create({
        purpose: 'identity_document',
        file: File.new(user.ids[2].url),
        }, {
        stripe_account: user.stripe_account_id,
      })
    end

    def create_person_token(identity_front, identity_verso, proof_of_address)
      return Stripe::Token.create({
        person: {
          verification: {
            document: {
              front: identity_front.id,
              back: identity_verso.id,
            },
            additional_document: {
              front: proof_of_address.id
            }
          },
        },
      })
    end

    def update_person(user, person_token)
      Stripe::Account.update_person(
        user.stripe_account_id,
        user.person_id,
        {
          person_token: person_token
        })    
    end


    def attributes_are_filled?
      user = self
      if user.token_account.nil?
        if user.email? && user.first_name? && user.last_name? && user.phone? && user.line1? && user.city? && user.postal_code? && user.date_of_birth.day.present? && user.date_of_birth.month.present? && user.date_of_birth.year.present?
          return true
        else
          return false
        end
      end
        return false
    end

    def create_connect_account
      user = self
      create_token = stripe_create_token

      user.update_column(:token_account, create_token.id)

      stripe_account = Stripe::Account.create({
        account_token: user.token_account,
        type: 'custom',
        business_profile: {
          mcc: 5691,
          url: "rockdontstock.com",
        },
        country: 'FR',
        email: user.email,
        capabilities: {
          card_payments: {requested: true},
          transfers: {requested: true},
        }
      })
      user.update_column(:stripe_account_id, stripe_account.id)
      user.update_column(:person_id, stripe_account['individual'].id)
    end

    def stripe_create_token
      user = self
      return Stripe::Token.create({
        account: {
          business_type: "individual",
          individual: {
            email: user.email,
            first_name: user.first_name,
            last_name: user.last_name,
            phone: "+33606860076",
            address: {
              line1: user.line1,
              city: user.city,
              postal_code: user.postal_code,
            },
            dob: {
              day: user.date_of_birth.day,
              month: user.date_of_birth.month,
              year: user.date_of_birth.year,
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
