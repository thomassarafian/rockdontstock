class SubscribeToNewsletterService
  def initialize(user)
    @user = user
    @gibbon = Gibbon::Request.new(api_key: ENV['MAILCHIMP_API_KEY'])
    @audience_id = ENV['MAILCHIMP_LIST_ID']
  end

  def home_page_signup
    @gibbon.lists(@audience_id).members.create(
      body: {
        email_address: @user['email'],
        status: "subscribed",
        merge_fields: {
          FNAME: @user['email']
        }
      }
    )
  end

  def call
    @gibbon.lists(@audience_id).members.create(
      body: {
        email_address: @user.email,
        status: "subscribed",
        merge_fields: {
          FNAME: @user.first_name,
          LNAME: @user.last_name
        }
      }
    )
  end
end

