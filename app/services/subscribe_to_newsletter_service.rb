class SubscribeToNewsletterService
  include ActiveModel::Validations
  
  def initialize(user)
    @user = user
    @gibbon = Gibbon::Request.new(api_key: ENV['MAILCHIMP_API_KEY'])
    @audience_id = ENV['MAILCHIMP_LIST_ID']
  end

  def home_page_signup
    begin
      @gibbon.lists(@audience_id).members.create(
        body: {
          email_address: @user['email'],
          status: "subscribed"
        }
      )
    rescue Gibbon::MailChimpError => e
      if e.title == "Member Exists"
        return "Tu es dejà inscrit à notre newsletter"
      else
        return  "Félicitation ! Tu vas bientôt recevoir nos offres"
      end
    end
  end

  def call
    @gibbon.lists(@audience_id).members.create(
      body: {
        email_address: @user.email,
        status: "subscribed",
        merge_fields: {
          PRENOM: @user.first_name,
          NOM: @user.last_name
        }
      }
    )
  end
end

