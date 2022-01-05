SibApiV3Sdk.configure do |config|
  config.api_key['api-key'] = ENV["SENDINBLUE_API_KEY"]
end

class Subscription
  
  def initialize(arg)
    case arg
    when User
      @user = arg
      @email = @user.email
      @attributes = {"NOM": "#{@user.last_name}", "PRENOM": "#{@user.first_name}", "AGE": "#{@user.date_of_birth}", "VILLE": "#{@user.last_name}", "SMS": "+33#{@user.phone}"}.as_json
      @attributes_for_guide = {"NOM": "#{@user.last_name}", "PRENOM": "#{@user.first_name}", "AGE": "#{@user.date_of_birth}", "VILLE": "#{@user.last_name}"}.as_json
    when String
      @email = arg
    end

    @sib = SibApiV3Sdk::ContactsApi.new
    begin
      @sib_contact = @sib.get_contact_info(@email)
    rescue SibApiV3Sdk::ApiError
      @sib_contact = nil
    end

    # @gibbon = Gibbon::Request.new(api_key: ENV['MAILCHIMP_API_KEY'])
    # @audience_id = ENV['MAILCHIMP_LIST_ID']
  end

  def as_seller
    if @sib_contact
      return if @sib_contact.list_ids.include?(7)

      sib_contact = SibApiV3Sdk::AddContactToList.new(ids: [@sib_contact.id])
      @sib.add_contact_to_list(7, sib_contact)
    else
      new_contact = SibApiV3Sdk::CreateContact.new(email: @user.email, attributes: @attributes, listIds: [7])
      @sib.create_contact(new_contact)
    end
  end

  def as_buyer
    if @sib_contact
      return if @sib_contact.list_ids.include?(6)

      sib_contact = SibApiV3Sdk::AddContactToList.new(ids: [@sib_contact.id])
      @sib.add_contact_to_list(6, sib_contact)
    else
      new_contact = SibApiV3Sdk::CreateContact.new(email: @user.email, attributes: @attributes, listIds: [6])
      @sib.create_contact(new_contact)
    end
  end
  
  # here we only have email, no User object
  def as_prospect
    if @sib_contact
      return if @sib_contact.list_ids.include?(3)

      sib_contact = SibApiV3Sdk::AddContactToList.new(ids: [@sib_contact.id])
      @sib.add_contact_to_list(3, sib_contact)
    else
      new_contact = SibApiV3Sdk::CreateContact.new(email: @email)
      @sib.create_contact(new_contact)
      Subscription.new(email: @email).as_prospect
    end
  end

  def as_user
    if @sib_contact
      return if @sib_contact.list_ids.include?(4)

      sib_contact = SibApiV3Sdk::AddContactToList.new(ids: [@sib_contact.id])
      @sib.add_contact_to_list(4, sib_contact)
    else
      new_contact = SibApiV3Sdk::CreateContact.new(email: @user.email, attributes: @attributes, listIds: [4])
      @sib.create_contact(new_contact)
    end
  end

  def to_lg_guide(list_id)
    if @sib_contact
      return if @sib_contact.list_ids.include?(list_id)

      sib_contact = SibApiV3Sdk::AddContactToList.new(ids: [@sib_contact.id])
      @sib.add_contact_to_list(list_id, sib_contact)
    else
      new_contact = SibApiV3Sdk::CreateContact.new(email: @user.email, attributes: @attributes_for_guide, listIds: [list_id])
      @sib.create_contact(new_contact)
    end
  end

end