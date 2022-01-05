class Subscription

  # IDs of sendinblue groups
  PROSPECTS_LIST = 3
  USERS_LIST = 4
  BUYERS_LIST = 6
  SELLERS_LIST = 7
  LC_REQUESTS_LIST = 15
  
  def initialize(arg)
    case arg
    when User
      @user = arg
      @email = @user.email
      @attributes = {"NOM": "#{@user.last_name}", "PRENOM": "#{@user.first_name}", "AGE": "#{@user.date_of_birth}", "VILLE": "#{@user.city}", "SMS": "+33#{@user.phone}"}.as_json
      @attributes_for_guide = {"NOM": "#{@user.last_name}", "PRENOM": "#{@user.first_name}", "AGE": "#{@user.date_of_birth}", "VILLE": "#{@user.city}"}.as_json
    when Authentication
      @user = arg
      @email = @user.email
      @attributes = {"NOM": "#{@user.last_name}", "PRENOM": "#{@user.first_name}", "AGE": "#{@user.age}", "VILLE": "#{@user.city}"}.as_json
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
    # @audience_id = ENV['MAILCHIMP_LIST_LIST']
  end

  def as_seller
    if @sib_contact
      return if @sib_contact.list_ids.include?(SELLERS_LIST)

      sib_contact = SibApiV3Sdk::AddContactToList.new(ids: [@sib_contact.id])
      @sib.add_contact_to_list(SELLERS_LIST, sib_contact)
    else
      new_contact = SibApiV3Sdk::CreateContact.new(email: @user.email, attributes: @attributes, listIds: [SELLERS_LIST])
      @sib.create_contact(new_contact)
    end
  end

  def as_buyer
    if @sib_contact
      return if @sib_contact.list_ids.include?(BUYERS_LIST)

      sib_contact = SibApiV3Sdk::AddContactToList.new(ids: [@sib_contact.id])
      @sib.add_contact_to_list(BUYERS_LIST, sib_contact)
    else
      new_contact = SibApiV3Sdk::CreateContact.new(email: @user.email, attributes: @attributes, listIds: [BUYERS_LIST])
      @sib.create_contact(new_contact)
    end
  end
  
  # here we only have email, no User object
  def as_prospect
    if @sib_contact
      return if @sib_contact.list_ids.include?(PROSPECTS_LIST)

      sib_contact = SibApiV3Sdk::AddContactToList.new(ids: [@sib_contact.id])
      @sib.add_contact_to_list(PROSPECTS_LIST, sib_contact)
    else
      new_contact = SibApiV3Sdk::CreateContact.new(email: @email)
      @sib.create_contact(new_contact)
      Subscription.new(email: @email).as_prospect
    end
  end

  def as_user
    if @sib_contact
      return if @sib_contact.list_ids.include?(USERS_LIST)

      sib_contact = SibApiV3Sdk::AddContactToList.new(ids: [@sib_contact.id])
      @sib.add_contact_to_list(USERS_LIST, sib_contact)
    else
      new_contact = SibApiV3Sdk::CreateContact.new(email: @user.email, attributes: @attributes, listIds: [USERS_LIST])
      @sib.create_contact(new_contact)
    end
  end

  def to_lc_guide(list_id)
    if @sib_contact
      return if @sib_contact.list_ids.include?(list_id)

      sib_contact = SibApiV3Sdk::AddContactToList.new(ids: [@sib_contact.id])
      @sib.add_contact_to_list(list_id, sib_contact)
    else
      new_contact = SibApiV3Sdk::CreateContact.new(email: @user.email, attributes: @attributes_for_guide, listIds: [list_id])
      @sib.create_contact(new_contact)
    end
  end

  def as_lc_requester
    if @sib_contact
      return if @sib_contact.list_ids.include?(LC_REQUESTS_LIST)

      sib_contact = SibApiV3Sdk::AddContactToList.new(ids: [@sib_contact.id])
      @sib.add_contact_to_list(LC_REQUESTS_LIST, sib_contact)
    else
      new_contact = SibApiV3Sdk::CreateContact.new(email: @user.email, attributes: @attributes, listIds: [LC_REQUESTS_LIST])
      @sib.create_contact(new_contact)
    end
  end

end