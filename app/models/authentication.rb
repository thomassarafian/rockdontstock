class Authentication < ApplicationRecord
  belongs_to :product
  has_many_attached :photos, service: Rails.application.config.active_storage.service, dependent: :detach

  delegate :price_in_cents, to: :product

  enum payment_status: { unpaid: 0, paid: 10 }
  enum payment_method: { card: 0 }

  validates :first_name, :last_name, :email, :date_of_birth, :newsletter, presence: true
  # validates :photos, presence: true
  validates :newsletter, acceptance: true

  def send_information_email
    photos_urls = self.photos.map{ |photo| photo.blob&.url }.compact.join("\n")

    Mailjet::Send.create(messages: [{
      'From'=> {
        'Email'=> "hello@rockdontstock.com",
        'Name'=> "Rock Don't Stock"
      },
      'To'=> [
        {
          'Email'=> "hello@rockdontstock.com",
          'Name'=> "Rock Don't Stock"
        }
      ],
      'TemplateID'=> 3482576,
      'TemplateLanguage'=> true,
      'Subject'=> "Nouvelle demande de Legit Check",
      'Variables'=> {
        "nom" => self.last_name,
        "prenom" => self.first_name,
        "email" => self.email,
        "naissance" => self.date_of_birth,
        "ville" => self.city,
        "photos" => photos_urls
      }
    }])
  end

  def price
    '%.2f' % (price_in_cents / 100.00)
  end

end
