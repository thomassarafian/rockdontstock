class Contact < MailForm::Base
  attribute :name
  attribute :email
  attribute :message
  attribute :object
  validates :name, presence: true
  validates :email, presence: true
  validates :message, presence: true
  validates :object, presence: true  
end
