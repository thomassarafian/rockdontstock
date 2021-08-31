# class SubscribeToNewsletterService
#   include ActiveModel::Validations
  
#   def initialize(user)
#     @user = user
#     @gibbon =  Gibbon::API.new(ENV['MAILCHIMP_API_KEY'])
#     #Gibbon::Request.new(api_key: ENV['MAILCHIMP_API_KEY'])
#     @audience_id = ENV['MAILCHIMP_LIST_ID']
#   end

#   def home_page_signup
#     begin
#       @gibbon.lists("f457fd3813").members.create(
#         body: {
#           email_address: @user['email'],
#           status: "subscribed"
#         }
#       )
#     rescue Gibbon::MailChimpError => e
#       if e.title == "Member Exists"
#         return "Tu es dejà inscrit à notre newsletter"
#       else
#         return  "Félicitation ! Tu vas bientôt recevoir nos offres"
#       end
#     end
#   end

#   def call
#     raise
#     @gibbon.lists("f457fd3813").members.create(
#       body: {
#         email_address: @user.email,
#         status: "subscribed",
#         merge_fields: {
#           PRENOM: @user.first_name,
#           NOM: @user.last_name
#         }
#       }
#     )
#   end
# end


class SubscribeToNewsletterService
  # MailchimpFailed = Class.new(ServiceActionError)
  def initialize(user)
    if ENV['MAILCHIMP_API_KEY']
      @user = user
      @mailchimp = Gibbon::Request.new(api_key: ENV['MAILCHIMP_API_KEY'], symbolize_keys: true)
      @mailchimp.timeout = 30
      @mailchimp.open_timeout = 30
    end
  end

  def call(user, subscribe = true)
    raise MailchimpFailed.new unless @mailchimp
    status = (subscribe ? 'subscribed' : 'unsubscribed')
    list(user).upsert(
      body: {
        email_address: @user['email'],
        status: status,
        # merge_fields: {
        #   FNAME:  user.first_name.to_s,
        #   LNAME: user.last_name.to_s,
        #   CNAME: user.company_name.to_s,
        #   PHONE: user.telephone.to_s
        # }
      }
    )
  rescue Gibbon::MailChimpError => e
    raise e
  end
  private

  def list(user)
    @mailchimp.lists(ENV['MAILCHIMP_LIST_ID']).members(
      @user['email'])
  end
end
