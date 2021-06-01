# require 'httparty'
# require 'json'

# auth = {
# 	username: ENV['SENDCLOUD_API_KEY'], 
# 	password: ENV['SENDCLOUD_SECRET_KEY']
# }

Rails.configuration.sendcloud = {
  api_key: ENV["SENDCLOUD_API_KEY"],
  secret_key: ENV["SENDCLOUD_SECRET_KEY"]
}


# get_carriers = HTTParty.get(
#                 "https://servicepoints.sendcloud.sc/api/v2/carriers/",
#                 basic_auth: auth)

# puts JSON.pretty_generate(JSON.parse(get_carriers.body))

# # get_parcels = HTTParty.get(
# # 			"https://panel.sendcloud.sc/api/v2/parcels",
# # 			basic_auth:  auth)

# #puts JSON.pretty_generate(JSON.parse(get_parcels.body))

# new_parcel_data = {
#   parcel: {
#     name: "Nils Bonnavaud",
#     company_name: "Rock Don't Stock",
#     address: "Place de la Comédie",
#     house_number: "11",
#     city: "Montpellier",
#     postal_code: "34000",
#     telephone: "+33676659036",
#     email: "nils.bonnavaud@hotmail.fr",
#     order_number: "1234567890",
#     weight: "1.000",
#     request_label: "true",
#     data: [],
#     country: "FR",
#     shipment: {
#      id: 8,
#     },
#     parcel_items: [],
#    	from_name: "Robert",
#     from_address_1: "rue du faubourg du temple",
#     from_address_2: "",
#     from_house_number: "127",
#     from_city: "Paris",
#     from_postal_code: "75012",
#     from_country: "FR",
#     from_telephone: "+31644332211",
#     from_email: "rob@gmail.com",
#     insured_value: 2000,
#     total_order_value_currency: "EUR",
#     total_order_value: "11.11",
#     quantity: 1,
#   }
# }

# create_parcel = HTTParty.post(
# 				"https://panel.sendcloud.sc/api/v2/parcels",
# 				body: new_parcel_data.to_json,
# 				:headers => { 'Content-Type' => 'application/json' },
# 				basic_auth: auth)


# puts JSON.pretty_generate(JSON.parse(create_parcel.body))

# # get_sender_adress = HTTParty.get(
# #   									'https://panel.sendcloud.sc/api/v2/user/addresses/sender',
# #  										basic_auth:  auth)

# # puts JSON.pretty_generate(JSON.parse(get_sender_adress.body))
