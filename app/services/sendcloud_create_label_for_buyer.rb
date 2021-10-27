class SendcloudCreateLabelForBuyer
  require 'json'
  def initialize(user, order)
    @user = user
    @order = order
    @auth = {
      username: ENV["SENDCLOUD_API_KEY"],
      password: ENV["SENDCLOUD_SECRET_KEY"]
    }
  end

  def create_label
    if @order.shipping_cost_cents == 883
      colissimo_second_parcel_data = {
        parcel: {
          name: @order.user.first_name + " " + @order.user.last_name,
          company_name: "",
          address: @order.user.line1,
          house_number: @order.user.line1.split(/\W+/)[0],
          city: @order.user.city,
          postal_code: @order.user.postal_code,
          telephone: @order.user.phone,
          email: @order.user.email,
          order_number: @order.id,
          weight: "1.5",
          request_label: "true",
          data: [],
          country: "FR",
          shipment: {
           id: 1066, #1680, #8 (pour les test), #@user.picker_data['id'],
           name: "Colissimo Home 1-2kg", #"Unstamped Letter",
          },
          parcel_items: [],
          from_name: "Nils Bonnavaud",
          from_address_1: "rue Massilian",
          from_address_2: "",
          from_house_number: "2",
          from_city: "Montpellier",
          from_postal_code: "34000",
          from_country: "FR",
          from_telephone: "+33676659036",
          from_email: "hello@rockdontstock.com",
          total_order_value_currency: "EUR",
          total_order_value: @order.price_cents / 100,
          quantity: 1,
        }
      }
      create_parcel = HTTParty.post("https://panel.sendcloud.sc/api/v2/parcels",
                      body: colissimo_second_parcel_data.to_json,
                      :headers => { 'Content-Type' => 'application/json' },
                      basic_auth: @auth)
    elsif @order.shipping_cost_cents == 505
      mondial_second_parcel_data = {
        parcel: {
          name: @order.user.first_name + " " + @order.user.last_name,
          company_name: "",
          address: @order.user.line1,
          house_number: @order.user.line1.split(/\W+/)[0],
          city: @order.user.city,
          postal_code: @order.user.postal_code,
          telephone: @order.user.phone,
          email: @order.user.email,
          order_number: @order.id,
          weight: "1.5",
          request_label: "true",
          data: [],
          country: "FR",
          shipment: {
           id: 1680, #1680, #8 (pour les test), #@user.picker_data['id'],
           name: "Mondial Relay Point Relais L 1-2kg", # "Mondial Relay Point Relais L 1-2kg", #"Unstamped Letter",
          },
          to_service_point: @user.picker_data['id'],
          parcel_items: [],
          from_name: "Nils Bonnavaud",
          from_address_1: "rue Massilian",
          from_address_2: "",
          from_house_number: "2",
          from_city: "Montpellier",
          from_postal_code: "34000",
          from_country: "FR",
          from_telephone: "+33676659036",
          from_email: "hello@rockdontstock.com",
          total_order_value_currency: "EUR",
          total_order_value: @order.price_cents / 100,
          quantity: 1,
        }
      }
      create_parcel = HTTParty.post("https://panel.sendcloud.sc/api/v2/parcels",
                      body: mondial_second_parcel_data.to_json,
                      :headers => { 'Content-Type' => 'application/json' },
                      basic_auth: @auth)
    end

    json_create_parcel = JSON.pretty_generate(JSON.parse(create_parcel.body))

    puts json_create_parcel

    puts "=============================="
    puts create_parcel.parsed_response['parcel']['id']
    # @order.update(sendcloud_order_id: create_parcel.parsed_response['parcel']['id'])
    @order.sendcloud_order_id_buyer = create_parcel.parsed_response['parcel']['id']
    # puts create_parcel.parsed_response['parcel']['tracking_url']
    
    File.open("app/assets/images/bon_livraison.pdf", "wb") do |f| 
      f.write HTTParty.get(create_parcel.parsed_response['parcel']['label']['label_printer'], basic_auth: @auth).body
    end


    label_file = open("app/assets/images/bon_livraison.pdf")
    base_64 = Base64.encode64(label_file.read)


    rds_mail = Mailjet::Send.create(messages: [{
      'From'=> {
        'Email'=> "elliot@rockdontstock.com",
        'Name'=> "Rock Don't Stock"
      },
      'To'=> [
        {
          'Email'=> "hello@rockdontstock.com",
          'Name'=> "Elliot & Nils"
        }
      ],
      'TemplateID'=> 3245119,
      'TemplateLanguage'=> true,
      'Subject'=> "Nouveau colis à expédier",
      'Variables'=> {
      },
      'Attachments'=> [{
        'ContentType'=> 'text/plain',
        'Filename'=> 'app/assets/images/bon_livraison.pdf',
        'Base64Content'=> base_64
      }]
    }])
    p rds_mail.attributes['Messages']

    seller_mail = Mailjet::Send.create(messages: [{
      'From'=> {
        'Email'=> "elliot@rockdontstock.com",
        'Name'=> "Rock Don't Stock"
      },
      'To'=> [
        {
          'Email'=> @order.sneaker.user.email,
          'Name'=> @order.sneaker.user.first_name
        }
      ],
      'TemplateID'=> 2966659,
      'TemplateLanguage'=> true,
      'Subject'=> "Paire authentifiée ! 🤝 ",
      'Variables'=> {
        "prenom" => @order.sneaker.user.first_name,
        "numero_commande" => @order.id,
        "modele_paire" => @order.sneaker.sneaker_db.name,
        "prix_de_vente" => @order.sneaker.price_cents / 100,
        "frais_de_livraison" => "5,05",
        "frais_authentification" => "0",
        "somme_vendeur" => (@order.sneaker.price_cents / 100) - 5.05
      }
    }])
    p seller_mail.attributes['Messages']

    buyer_mail = Mailjet::Send.create(messages: [{
      'From'=> {
        'Email'=> "elliot@rockdontstock.com",
        'Name'=> "Rock Don't Stock"
      },
      'To'=> [
        {
          'Email'=> @order.user.email,
          'Name'=> @order.user.first_name
        }
      ],
      'TemplateID'=> 2966878,
      'TemplateLanguage'=> true,
      'Subject'=> "Paire authentifiée ! 🤝",
      'Variables'=> {
        "prenom" => @order.user.first_name,
        "modele_paire" => @order.sneaker.sneaker_db.name
      }
    }])
    p buyer_mail.attributes['Messages']
  end
end
  