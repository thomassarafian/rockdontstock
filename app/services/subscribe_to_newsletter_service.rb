class SubscribeToNewsletterService
  include ActiveModel::Validations
  require 'uri'
  require 'net/http'
  require 'openssl'
  
  def initialize(user)
    @user = user
    @gibbon = Gibbon::Request.new(api_key: ENV['MAILCHIMP_API_KEY'])
    @audience_id = ENV['MAILCHIMP_LIST_ID']
  end

  def user_is_seller
    url = URI("https://api.sendinblue.com/v3/contacts/#{@user.email}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Put.new(url)
    request["Accept"] = 'application/json'
    request["Content-Type"] = 'application/json'
    request["api-key"] = ENV['SENDINBLUE_API_KEY']
    request.body = "{\"listIds\":[7]}"
    begin
      response = http.request(request)
      puts response.read_body
    rescue e 
      puts "Exception when calling ContactsApi->update_contact: #{e}"
    end
  end

  def user_is_buyer
    url = URI("https://api.sendinblue.com/v3/contacts/#{@user.email}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Put.new(url)
    request["Accept"] = 'application/json'
    request["Content-Type"] = 'application/json'
    request["api-key"] = ENV['SENDINBLUE_API_KEY']
    request.body = "{\"listIds\":[6]}"
    begin
      response = http.request(request)
      puts response.read_body
    rescue e 
      puts "Exception when calling ContactsApi->update_contact: #{e}"
    end
  end

  def home_page_signup
    url = URI("https://api.sendinblue.com/v3/contacts")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(url)
    request["Accept"] = 'application/json'
    request["Content-Type"] = 'application/json'
    request["api-key"] = ENV['SENDINBLUE_API_KEY']
    request.body = "{\"listIds\":[3],\"updateEnabled\":false,\"email\":\"#{@user['email']}\"}"
    begin
      response = http.request(request)
      puts response.read_body
    rescue e
      puts "Exception when calling ContactsApi->create_contact: #{e}"
    end
    # begin
    #   @gibbon.lists(@audience_id).members.create(
    #     body: {
    #       email_address: @user['email'],
    #       status: "subscribed"
    #     }
    #   )
    # rescue Gibbon::MailChimpError => e
    #   if e.title == "Member Exists"
    #     return "Tu es dejà inscrit à notre newsletter"
    #   else
    #     return  "Félicitation ! Tu vas bientôt recevoir nos offres"
    #   end
    # end
  end

  def call
    url = URI("https://api.sendinblue.com/v3/contacts")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(url)
    request["Accept"] = 'application/json'
    request["Content-Type"] = 'application/json'
    request["api-key"] = ENV['SENDINBLUE_API_KEY']  #'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'
    request.body = "{\"attributes\":{\"NOM\":\"#{@user.last_name}\",\"PRENOM\":\"#{@user.first_name}\",\"AGE\":\"#{@user.date_of_birth}\",\"VILLE\":\"#{@user.city}\",\"SMS\":\"+33#{@user.phone}\"},\"listIds\":[4],\"updateEnabled\":false,\"email\":\"#{@user.email}\"}"
    begin
      response = http.request(request)
      puts response.read_body
    rescue e
      puts "Exception when calling ContactsApi->create_contact: #{e}"
    end

    # begin
    #   @gibbon.lists(@audience_id).members.create(
    #     body: {
    #       email_address: @user.email,
    #       status: "subscribed",
    #       merge_fields: {
    #         PRENOM: @user.first_name,
    #         NOM: @user.last_name
    #       }
    #     }
    #   )
    # rescue  Gibbon::MailChimpError => e
    #   if e.title == "Member Exists"
    #     return "Tu es dejà inscrit à notre newsletter"
    #   # else
    #   #   return  "Félicitation ! Tu vas bientôt recevoir nos offres"
    #   end
    # end
  end
end

