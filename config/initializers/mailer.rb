# require 'MailchimpTransactional'


# client = MailchimpTransactional::Client.new(ENV['MAILCHIMPTRANS_API_KEY'])
# message = {
#   from_email: "hello@example.com",
#   subject: "Hello world",
#   text: "Welcome to Mailchimp Transactional!",
#   to: [
#     {
#       email: "thomassarafian@gmail.com",
#       type: "to"
#     }
#   ]
# }

# begin
#   response = client.messages.send(message)
#   p response
# rescue MailchimpTransactional::ApiError => e
#   puts "Error: #{e}"
# end
# require 'uri'
# require 'net/http'
# require 'openssl'

# url = URI("https://api.mangopay.com/v2.01/oauth/token/")

# http = Net::HTTP.new(url.host, url.port)
# http.use_ssl = true
# http.verify_mode = OpenSSL::SSL::VERIFY_NONE

# request = Net::HTTP::Post.new(url)
# request["content-type"] = 'application/x-www-form-urlencoded'
# request.body = "client_id=rockdontstoctest&api_key=ovyjek5X6KErk7BLGBNUTd5dDWVEk4kRTPUkcxQzq1GQJ4VMqM"

# response = http.request(request)
# puts response.read_body