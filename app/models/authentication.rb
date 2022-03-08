class Authentication < ApplicationRecord
  has_many_attached :photos, service: :cloudinary, dependent: :detach

  enum payment_status: { unpaid: 0, paid: 10 }

  validates :first_name, :last_name, :email, :date_of_birth, :city, :newsletter, :photos, presence: true
  validates :newsletter, acceptance: true

  def send_information_email
    photos_urls = self.photos.map{ |photo| photo.blob.url }.join("\n")

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

end
