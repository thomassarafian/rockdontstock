# require 'uri'
# require 'net/http'

# url = URI("https://api.easyship.com/rate/v1/rates")

# http = Net::HTTP.new(url.host, url.port)
# http.use_ssl = true

# request = Net::HTTPrequire 'rubygems' if RUBY_VERSION < '1.9'
# require 'rest_client'

# values = '{
#   "origin_country_alpha2": "SG",
#   "origin_postal_code": "WC2N",
#   "destination_country_alpha2": "US",
#   "destination_postal_code": "10030",
#   "taxes_duties_paid_by": "Sender",
#   "is_insured": false,
#   "items": [
#     {
#       "actual_weight": 1.2,
#       "height": 10,
#       "width": 15,
#       "length": 20,
#       "category": "mobiles",
#       "declared_currency": "SGD",
#       "declared_customs_value": 100
#     }
#   ]
# }'

# headers = {
#   :content_type => 'application/json',
#   :authorization => 'Bearer <YOUR EASYSHIP API TOKEN>'
# }

# response = RestClient.post 'https://api.easyship.com/rate/v1/rates', values, headers
# puts response::Post.new(url)
# request.body = "{\"origin_country_alpha2\":\"SG\",\"origin_postal_code\":\"WC2N\",\"destination_country_alpha2\":\"US\",\"destination_postal_code\":\"10030\",\"taxes_duties_paid_by\":\"sender\",\"is_insured\":\"false\",\"items\":{\"actual_weight\":1.2,\"height\":10,\"width\":15,\"length\":20,\"category\":\"mobiles\",\"declared_currency\":\"sgd\",\"declared_customs_value\":100}}"

# response = http.request(request)
# puts response.read_body
