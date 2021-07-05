require 'json'

class User < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with:  /\A[^@][\w.-]+@[\w.-]+[.][a-z]{2,4}\z/i }
  # validates :iban, uniqueness: true # créé un bug 

  has_many :sneakers, dependent: :destroy
  has_many :orders, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable
	devise :database_authenticatable, :registerable,
    	:recoverable, :rememberable, :validatable
  devise :omniauthable, omniauth_providers: [:facebook, :google_oauth2]

  has_many_attached :ids

  after_update :create_connect_account

  # validate :correct_ids_type?

  # after_create :send_notification # a configurer avec mailjet 

  # after_update :send_ids #, if: :ids_are_filled?

  after_update :convert_picker_data_to_json, if: :picker_data_is_filled?

  # after_create :subscribe_to_newsletter

  # after_update :send_label, if: :picker_data_is_converted?
  

  private

  def subscribe_to_newsletter
    SubscribeToNewsletterService.new(self).call
  end

  def picker_data_is_converted?
    user = self
    if user.picker_data? && user.picker_data.class == Hash && (user.line1? && user.postal_code? && user.city?)
      return true
    else
      return false
    end
  end

  def convert_picker_data_to_json
    user = self
    user.update_column(:picker_data, JSON.parse(user.picker_data))
  end

  def picker_data_is_filled?
    user = self
     if user.picker_data? && user.picker_data.class != Hash 
      return true
    else
      return false
     end 
  end

  #le but c'est de creer les documents
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
    # if user.ids[0].present? && user.ids[1].present? && user.ids[2].present? 
      # return true
    # else
      # return false
    # end
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
      file: File.new("/Users/thomassarafian/Desktop/default_avatar\ 3.png"),
      }, {
      stripe_account: user.stripe_account_id,
    })
  end

  def retrieve_verso_id(user)
    return Stripe::File.create({
      purpose: 'identity_document',
      file: File.new("/Users/thomassarafian/Desktop/default_avatar\ 3.png"),
      }, {
      stripe_account: user.stripe_account_id,
    })
  end

  def retrieve_proof_of_address(user)
    return Stripe::File.create({
      purpose: 'identity_document',
      file: File.new("/Users/thomassarafian/Desktop/default_avatar\ 3.png"),
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


  # def attributes_are_filled?
  #   user = self
  #   puts " attributes_are_filled"
  #   puts " attributes_are_filled"
  #   puts " attributes_are_filled"
  #   puts " attributes_are_filled"
  #   puts " attributes_are_filled"
  #   puts " attributes_are_filled"

  #   if user.token_account.nil?
  #     if user.email? && user.first_name? && user.last_name? && user.phone? && user.line1? && user.city? && user.postal_code? && user.date_of_birth.day.present? && user.date_of_birth.month.present? && user.date_of_birth.year.present?
  #       return true
  #     else
  #       return false
  #     end
  #   end
  #     return false
  # end

  def create_connect_account
    raise
    Stripe::StripeCreateConnectAccount.new(self)  
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
