class Contact < MailForm::Base
  attribute :name, validate: true
  attribute :email, validate: true
  attribute :message, validate: true
  attribute :object, validate: true
  
end
