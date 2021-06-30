require 'json'


class SendcloudCreateLabel

  def initialize(user, order)
    @user = user
    @order = order
    @auth = {
      username: ENV["SENDCLOUD_API_KEY"],
      password: ENV["SENDCLOUD_SECRET_KEY"]
    }
  end

  def create_label
    first_parcel_data = {
      parcel: {
        name: "Nils Bonnavaud",
        company_name: "Rock Don't Stock",
        address: "Place de la Comédie",
        house_number: "11",
        city: "Montpellier",
        postal_code: "34000",
        telephone: "+33676659036",
        email: "nilsbonna@hotmail.fr",
        order_number: @order.id,
        weight: "1.5",
        request_label: "true",
        data: [],
        country: "FR",
        shipment: {
         id: 8,#1680, #@user.picker_data['id'],
         name: "Unstamped Letter", #"Mondial Relay Point Relais L 1-2kg",
        },
        # to_service_point: @user.picker_data['id'],
        parcel_items: [],
        from_name: @order.sneaker.user.first_name + " " + @order.sneaker.user.last_name,
        from_address_1: @order.sneaker.user.line1,
        from_address_2: "",
        from_house_number: @order.sneaker.user.line1.split(/\W+/)[0],
        from_city: @order.sneaker.user.city,
        from_postal_code: @order.sneaker.user.postal_code,
        from_country: "FR",
        from_telephone: "0606860076", #@order.sneaker.user.phone? ? @order.sneaker.user.phone : "",
        from_email: @order.sneaker.user.email,
        total_order_value_currency: "EUR",
        total_order_value: @order.sneaker.price_cents / 100,
        quantity: 1,
      }
    }
    create_parcel = HTTParty.post(
         "https://panel.sendcloud.sc/api/v2/parcels",
         body: first_parcel_data.to_json,
         :headers => { 'Content-Type' => 'application/json' },
         basic_auth: @auth)
    puts JSON.pretty_generate(JSON.parse(create_parcel.body))
    

    puts "=============================="
    
    File.open("app/assets/images/my_file.pdf", "wb") do |f| 
      f.write HTTParty.get(create_parcel.parsed_response['parcel']['label']['label_printer'], basic_auth: @auth).body
    end

    label_file = open("app/assets/images/my_file.pdf")
    base_64 = Base64.encode64(label_file.read)


    variable = Mailjet::Send.create(messages: [{
        'From'=> {
            'Email'=> 'sarafianthomas@gmail.com',
            'Name'=> 'Mailjet Pilot'
        },
        'To'=> [
            {
                'Email'=> 'thomassarafian@gmail.com',
                'Name'=> 'passenger 1'
            }
        ],
        'Subject'=> 'Your email coded plan!',
        'TextPart'=> 'Dear passenger 1, welcome to Mailjet! May the delivery force be with you!',
        'HTMLPart'=> '<h3>Dear passenger 1, welcome to <a href=\'https://www.mailjet.com/\'>Mailjet</a>!</h3><br />May the delivery force be with you!',
        'Attachments'=> [
            {
                'ContentType'=> 'text/plain',
                'Filename'=> 'app/assets/images/my_file.pdf',
                'Base64Content'=> base_64
            }
        ]
    }])


    # https://panel.sendcloud.sc/api/v2/labels/normal_printer/113233996?start_from=0
    # https://panel.sendcloud.sc/api/v2/labels/label_printer/113233996

    # create_parcel.parsed_response['parcel']['label']['normal_printer'][0-3]
    # create_parcel.parsed_response['parcel']['label']['label_printer']

    # get_pdf = HTTParty.get(create_parcel.parsed_response['parcel']['label']['label_printer'], basic_auth: auth)

    # pdf_label = get_pdf_label(create_parcel.parsed_response['parcel']['id'])
    
    # puts "==========================="
    # puts pdf

    # # raise
    # puts "==========================="
    # puts pdf_label
    # puts "==========================="
    # puts JSON.pretty_generate(JSON.parse(pdf_label.body))
    # puts "==========================="

    # puts JSON.pretty_generate(JSON.parse(create_parcel.body))

    # get_sender_adress = HTTParty.get(
    #                     'https://panel.sendcloud.sc/api/v2/user/addresses/sender',
    #                     basic_auth:  auth)

    # service_points = {
    #   carrier: "Mondial Relay",
    #   country: "FR",
      
    # }


    # puts JSON.pretty_generate(JSON.parse(get_sender_adress.body))

    # get_service_points = HTTParty.get(
    #                 "https://servicepoints.sendcloud.sc/api/v2/service-points/",
    #                 basic_auth: auth)

    # puts JSON.pretty_generate(JSON.parse(get_carriers.body))

    # get_parcels = HTTParty.get(
    #       "https://panel.sendcloud.sc/api/v2/parcels",
    #       basic_auth:  auth)

    #puts JSON.pretty_generate(JSON.parse(get_parcels.body))



  end

  private

 

  






end
