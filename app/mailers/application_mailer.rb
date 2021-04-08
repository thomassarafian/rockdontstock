class ApplicationMailer < ActionMailer::Base
  default from: 'elliot@rockdontstock.com'
  default to: 'elliot@rockdontstock.com'

  layout 'mailer'
end
