require 'MailchimpTransactional'


client = MailchimpTransactional::Client.new(ENV['MAILCHIMPTRANS_API_KEY'])
message = {
  from_email: "hello@example.com",
  subject: "Hello world",
  text: "Welcome to Mailchimp Transactional!",
  to: [
    {
      email: "thomassarafian@gmail.com",
      type: "to"
    }
  ]
}

begin
  response = client.messages.send(message)
  p response
rescue MailchimpTransactional::ApiError => e
  puts "Error: #{e}"
end
