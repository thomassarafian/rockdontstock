# require 'uri'
# require 'net/http'
# require 'openssl'

# url = URI("https://api.sendinblue.com/v3/contacts")

# http = Net::HTTP.new(url.host, url.port)
# http.use_ssl = true

# request = Net::HTTP::Post.new(url)
# request["Accept"] = 'application/json'
# request["Content-Type"] = 'application/json'
# request["api-key"] = ENV['SENDINBLUE_API_KEY']  #'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'
# request.body = "{\"attributes\":{\"NOM\":\"#{}\",\"PRENOM\":\"timeo\",\"AGE\":\"2004-01-11\",\"VILLE\":\"LYON\",\"SMS\":\"+330606860072\"},\"listIds\":[6],\"updateEnabled\":false,\"email\":\"thomaarafian@gmail.com\"}"



# begin
#   response = http.request(request)
#   puts response.read_body
# rescue e
#   puts "Exception when calling ContactsApi->create_contact: #{e}"
# end



# api_instance = SibApiV3Sdk::ListsApi.new

# list_id = 4 # Integer | Id of the list

# contact_emails = SibApiV3Sdk::AddContactToList.new(emails: "thomassarafian@gmail.com") # AddContactToList | Emails addresses OR IDs of the contacts


# begin
#   #Add existing contacts to a list
#   result = api_instance.add_contact_to_list(list_id, contact_emails)
#   p result
# rescue SibApiV3Sdk::ApiError => e
#   puts "Exception when calling AccountApi->get_account: #{e}"
# end
