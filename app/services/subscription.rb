class Subscription
  
  # NOTICE
  # Subscription can be instantiated by passing a User, Authentication or just plain email.
  # SMS must be unique, in 33XXXXXXXXX format

  # IDs of sendinblue groups
  PROSPECTS_LIST = 3
  USERS_LIST = 4
  BUYERS_LIST = 6
  SELLERS_LIST = 7
  LC_REQUESTS_LIST = 15


  def initialize(arg)

    # Init attributes
    if arg.is_a?(User) || arg.is_a?(Authentication)
      obj = {
        NOM: arg.last_name,
        PRENOM: arg.first_name,
        AGE: arg.date_of_birth,
        VILLE: arg.city
      }
      obj = obj.merge(SMS: "33#{arg.phone.last(9)}") if arg.is_a?(User) && arg.phone_valid?
      @attributes = obj
      @email = arg.email
    elsif arg.is_a?(String)
      @email = arg
    else
      raise ArgumentError
    end

    # Init API and check if user is already stored
    @sib = SibApiV3Sdk::ContactsApi.new
    begin
      @sib_contact = @sib.get_contact_info(@email)
    rescue SibApiV3Sdk::ApiError => e
      @sib_contact = nil
    end
  end

  def as_seller
    if @sib_contact
      return if @sib_contact.list_ids.include?(SELLERS_LIST)

      sib_contact = SibApiV3Sdk::AddContactToList.new(ids: [@sib_contact.id])
      @sib.add_contact_to_list(SELLERS_LIST, sib_contact)
    else
      new_contact = SibApiV3Sdk::CreateContact.new(email: @email, attributes: @attributes, listIds: [SELLERS_LIST])
      @sib.create_contact(new_contact)
    end
  end

  def as_buyer
    if @sib_contact
      return if @sib_contact.list_ids.include?(BUYERS_LIST)

      sib_contact = SibApiV3Sdk::AddContactToList.new(ids: [@sib_contact.id])
      @sib.add_contact_to_list(BUYERS_LIST, sib_contact)
    else
      new_contact = SibApiV3Sdk::CreateContact.new(email: @email, attributes: @attributes, listIds: [BUYERS_LIST])
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
      Subscription.new(@email).as_prospect
    end
  end

  def as_user
    if @sib_contact
      return if @sib_contact.list_ids.include?(USERS_LIST)

      sib_contact = SibApiV3Sdk::AddContactToList.new(ids: [@sib_contact.id])
      @sib.add_contact_to_list(USERS_LIST, sib_contact)
    else
      new_contact = SibApiV3Sdk::CreateContact.new(email: @email, attributes: @attributes, listIds: [USERS_LIST])
      @sib.create_contact(new_contact)
    end
  end

  def to_lc_guide(list_id)
    if @sib_contact
      return if @sib_contact.list_ids.include?(list_id)

      sib_contact = SibApiV3Sdk::AddContactToList.new(ids: [@sib_contact.id])
      @sib.add_contact_to_list(list_id, sib_contact)
    else
      new_contact = SibApiV3Sdk::CreateContact.new(email: @email, attributes: @attributes, listIds: [list_id])
      @sib.create_contact(new_contact)
    end
  end

  def as_lc_requester
    if @sib_contact
      return if @sib_contact.list_ids.include?(LC_REQUESTS_LIST)

      sib_contact = SibApiV3Sdk::AddContactToList.new(ids: [@sib_contact.id])
      @sib.add_contact_to_list(LC_REQUESTS_LIST, sib_contact)
    else
      new_contact = SibApiV3Sdk::CreateContact.new(email: @email, attributes: @attributes, listIds: [LC_REQUESTS_LIST])
      @sib.create_contact(new_contact)
    end
  end

end