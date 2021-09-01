class User < ApplicationRecord
  require 'json'
  
  has_many :sneakers, dependent: :destroy
  has_many :orders, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable
  devise :database_authenticatable, :registerable,
      :recoverable, :rememberable, :validatable
  devise :omniauthable, omniauth_providers: [:facebook, :google_oauth2]

  has_many_attached :ids

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with:  /\A[^@][\w.-]+@[\w.-]+[.][a-z]{2,4}\z/i }
  validates :phone, length: {is: 10}, format: { with: /^[0-9]*$/, multiline: true  }, on: [:edit, :update]
  validates :date_of_birth, presence: true
  validates :iban, presence: true
  validate :date_of_birth, if: :user_over_13, on: [:create, :update]

  after_update :create_connect_account

  # validate :correct_ids_type?

  # after_update :send_ids #, if: :ids_are_filled?

  after_update :convert_picker_data_to_json, if: :picker_data_is_filled?

  after_create :subscribe_to_newsletter
  after_create :send_welcome

  # after_update :send_label, if: :picker_data_is_converted?
  

  private

  def user_over_13
    dob = self.date_of_birth
    now = Time.now.utc.to_date
    if dob.nil? || dob.year < 1950 || dob.year >= now.year
      errors.add(:date_of_birth, " : Format invalide")
      return false
    end
    age = now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
    if age <= 13
      errors.add(:date_of_birth, " : Tu dois avoir au moins 13 ans")
    end
  end

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



  def age(dob)
    now = Time.now.utc.to_date
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end
  
  def attributes_are_filled?(user)
    if user.email? && user.first_name? && user.last_name? && user.phone? && user.line1? && user.city? && user.postal_code? && user.date_of_birth.day.present? && user.date_of_birth.month.present? && user.date_of_birth.year.present?
      if age(user.date_of_birth) < 13
        flash.now[:alert]  = "NOT OLD ENOUGH"
        return false
      elsif !user.token_account.nil?
        return false
      else
        return true
      end
    else 
      return false
    end
  end

  def create_connect_account
    if attributes_are_filled?(self)
      Stripe::StripeCreateConnectAccount.new(self)  
    end
  end

  def send_welcome
    variable = Mailjet::Send.create(messages: [{
      'From'=> {
        'Email'=> "elliot@rockdontstock.com",
        'Name'=> "Rock Don't Stock"
      },
      'To'=> [
        {
          'Email'=> self.email,
          'Name'=> self.first_name
        }
      ],
      'TemplateID'=> 2961026,
      'TemplateLanguage'=> true,
      'Subject'=> "Inscription validée !",
      'Variables'=> {
        "prenom" => self.first_name,
        "compte_rockdontstock" => 'https://www.rockdontstock.com/me'
      }
    }])
  end

    
  def self.create_from_google_data(auth)
    user_params = auth.slice("provider", "uid")
    user_params.merge! auth.info.slice("email", "first_name", "last_name", "birthday")
    user_params[:picture_url] = auth.info.image
    user_params[:token] = auth.credentials.token
    user_params[:token_expiry] = Time.at(auth.credentials.expires_at)
    
    # user_params[:date_of_birth] =  Date.strptime(auth.info.birthday,'%d/%m/%Y')
    
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
    user_params.merge! auth.info.slice("email", "first_name", "last_name", "birthday")
    user_params[:picture_url] = auth.info.image
    user_params[:date_of_birth] =  Date.strptime(auth.extra.raw_info.birthday,'%d/%m/%Y')

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
