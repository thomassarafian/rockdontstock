class SendcloudCreateLabel
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
    first_parcel_data = {
      parcel: {
        name: "Nils Bonnavaud",
        company_name: "Rock Don't Stock",
        address: "rue Massilian",
        house_number: "2",
        city: "Montpellier",
        postal_code: "34000",
        telephone: "+33676659036",
        email: "hello@rockdontstock.com",
        order_number: @order.id,
        weight: "1.5",
        request_label: "true",
        data: [],
        country: "FR",
        shipment: {
         id: 1680, #8 (pour les test), #@user.picker_data['id'],
         name: "Mondial Relay Point Relais L 1-2kg", #"Unstamped Letter",
        },
        to_service_point: 10603692,
        parcel_items: [],
        from_name: @order.sneaker.user.first_name + " " + @order.sneaker.user.last_name,
        from_address_1: @order.sneaker.user.line1,
        from_address_2: "",
        from_house_number: @order.sneaker.user.line1.split(/\W+/)[0],
        from_city: @order.sneaker.user.city,
        from_postal_code: @order.sneaker.user.postal_code,
        from_country: "FR",
        # from_telephone: "+33#{@order.sneaker.user.phone}", #"0606860076", #@order.sneaker.user.phone? ? @order.sneaker.user.phone : "",
        from_email: @order.sneaker.user.email,
        total_order_value_currency: "EUR",
        total_order_value: @order.total_price_cents / 100,
        quantity: 1,
      }
    }
    create_parcel = HTTParty.post("https://panel.sendcloud.sc/api/v2/parcels",
                    body: first_parcel_data.to_json,
                    :headers => { 'Content-Type' => 'application/json' },
                    basic_auth: @auth)

    json_create_parcel = JSON.pretty_generate(JSON.parse(create_parcel.body))

    puts json_create_parcel

    puts "=============================="
    puts create_parcel.parsed_response['parcel']['id']
    # @order.update(sendcloud_order_id_seller: create_parcel.parsed_response['parcel']['id'])
    @order.sendcloud_order_id_seller = create_parcel.parsed_response['parcel']['id']
    # puts create_parcel.parsed_response['parcel']['tracking_url']

    File.open("app/assets/images/bon_livraison.pdf", "wb") do |f| 
      f.write HTTParty.get(create_parcel.parsed_response['parcel']['label']['label_printer'], basic_auth: @auth).body
    end
    label_file = open("app/assets/images/bon_livraison.pdf")
    base_64 = Base64.encode64(label_file.read)

    variable = Mailjet::Send.create(messages: [{
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
      'TemplateID'=> 2961165,
      'TemplateLanguage'=> true,
      'Subject'=> "Ta paire a été vendue 🙌 #{@order.sneaker.sneaker_db.name}",
      'Variables'=> {
        "modele_paire" => @order.sneaker.sneaker_db.name,
        "prenom" => @order.sneaker.user.first_name,
        "numero_commande" => @order.id,
        "prix_de_vente" => @order.sneaker.price_cents.to_f / 100,
        "frais_de_livraison" => "5,05",  
        "frais_authentification" => (@order.service_cents.to_f / 100) / 2,
        "somme_vendeur" => ((@order.sneaker.price_cents.to_f / 100) - 5.05) , # - (@order.service_cents / 100)),
        "lien_conseils_expédition" => "https://www.rockdontstock.com/faq"
      },
      'Attachments'=> [{
        'ContentType'=> 'text/plain',
        'Filename'=> 'app/assets/images/bon_livraison.pdf',
        'Base64Content'=> base_64
      }]
    }])
    p variable.attributes['Messages']

    variable2 = Mailjet::Send.create(messages: [{
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
      'TemplateID'=> 2966808,
      'TemplateLanguage'=> true,
      'Subject'=> "Félicitations pour ton achat 🙌 #{@order.sneaker.sneaker_db.name}",
      'Variables'=> {
        "modele_paire" => @order.sneaker.sneaker_db.name,
        "prenom" => @order.user.first_name,
        # "tracking_url_commande" => create_parcel.parsed_response['parcel']['tracking_url'],
        "compte_rockdontstock" => "https://www.rockdontstock.com/me/items",
        "numero_commande" => @order.id,
        "prix_de_vente" => @order.sneaker.price_cents.to_f / 100,
        "frais_de_livraison" => @order.shipping_fee_cents.to_f / 100, 
        "frais_authentification" => (@order.service_cents.to_f / 100) / 2,
        "prix_tot_paye_par_acheteur" => (@order.sneaker.price_cents.to_f / 100) + (@order.shipping_fee_cents.to_f / 100) + ((@order.service_cents.to_f / 100) / 2) 
      }
    }])
    p variable2.attributes['Messages']
  end

end
