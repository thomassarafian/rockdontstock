require 'json'


class SendcloudCreateLabel

  def initialize(user, order)
    @user = user
    @order = order
  end


  def create_label

    auth = {
      username: ENV["SENDCLOUD_API_KEY"],
      password: ENV["SENDCLOUD_SECRET_KEY"]
    }
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
        weight: "1.000",
        request_label: "true",
        data: [],
        country: "FR",
        shipment: {
         id: 8, #@user.picker_data['id'],
        },
        parcel_items: [],
        from_name: @order.sneaker.user.first_name + " " + @order.sneaker.user.last_name,
        from_address_1: @order.sneaker.user.line1,
        from_address_2: "",
        from_house_number: @order.sneaker.user.line1.split(/\W+/)[0],
        from_city: @order.sneaker.user.city,
        from_postal_code: @order.sneaker.user.postal_code,
        from_country: "FR",
        from_telephone: @order.sneaker.user.phone? ? @order.sneaker.user.phone : "",
        from_email: @order.sneaker.user.email,
        total_order_value_currency: "EUR",
        total_order_value: @order.sneaker.price_cents / 100,
        quantity: 1,
      }
    }
    p " IT S DOOOOOOOOOONE"
    # create_parcel = HTTParty.post(
    #      "https://panel.sendcloud.sc/api/v2/parcels",
    #      body: first_parcel_data.to_json,
    #      :headers => { 'Content-Type' => 'application/json' },
    #      basic_auth: auth)
    # puts JSON.pretty_generate(JSON.parse(create_parcel.body))
  end

  private

 

  






end
