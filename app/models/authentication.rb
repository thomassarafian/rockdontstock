class Authentication < ApplicationRecord
  has_many_attached :photos, service: :cloudinary, dependent: :detach

  enum payment_status: { unpaid: 0, paid: 10 }

  after_create :send_information_email

  private

  def send_information_email
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
        "age" => self.age,
        "ville" => self.city
      }
    }])
  end

end
