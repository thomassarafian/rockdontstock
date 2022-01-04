class Subscription
  
  def initialize(user: nil, email: nil)
    if user
      @user = user
      @email = @user.email
    end
    if email
      @email = email
    end

    @sib = SibApiV3Sdk::ContactsApi.new
    begin
      @sib_contact = @sib.get_contact_info(@email)
    rescue SibApiV3Sdk::ApiError
      @sib_contact = nil
    end

    @gibbon = Gibbon::Request.new(api_key: ENV['MAILCHIMP_API_KEY'])
    @audience_id = ENV['MAILCHIMP_LIST_ID']
  end

  def as_seller
    if @sib_contact
      return if @sib_contact.list_ids.include?(7)
      sib_contact = SibApiV3Sdk::AddContactToList.new(ids: [@sib_contact.id])
      @sib.add_contact_to_list(7, sib_contact)
    else
      create_and_save_to_list(7)
    end
  end

  def as_buyer
    if @sib_contact
      return if @sib_contact.list_ids.include?(6)
      sib_contact = SibApiV3Sdk::AddContactToList.new(ids: [@sib_contact.id])
      @sib.add_contact_to_list(6, sib_contact)
    else
      create_and_save_to_list(6)
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
      create_and_save_to_list(4)
    end
  end

  private

  def create_and_save_to_list(list_id)
    new_contact = SibApiV3Sdk::CreateContact.new(
      email: @user.email,
      list_ids: [list_id],
      attributes: {
        "NOM": @user.last_name,
        "PRENOM": @user.first_name,
        "AGE": @user.date_of_birth,
        "VILLE": @user.city,
        "SMS": @user.phone,
      }
    )
    @sib.create_contact(new_contact)
  end

end