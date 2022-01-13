class Authentication < ApplicationRecord
  has_many_attached :photos, service: :cloudinary, dependent: :detach

  enum payment_status: { unpaid: 0, paid: 10 }

  before_update :send_information_email, if: -> { payment_status_changed? && payment_status == "paid" }

  private

  def send_information_email
    Mailjet::Send.create(messages: [{
      'From'=> {
        'Email'=> "hello@rockdontstock.com",
        'Name'=> "Rock Don't Stock"
      },
      'To'=> [
        {
          'Email'=> "nayow@yopmail.com",
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
