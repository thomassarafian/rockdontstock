class Forest::OrdersController < ForestLiana::SmartActionsController
  def cancel_sale_after_48h
    order_id = ForestLiana::ResourcesGetter.get_ids_from_request(params, 0).first

    @order = Order.find(order_id)
    
    # Vente annulé
    @order.update(state: "Abandon")
    
    # Remettre la paire en ligne
    @order.sneaker.update(state: 1)

    # Rembourser l'acheteur 
    puts "======================================================="
    puts @order_session = Stripe::Checkout::Session.retrieve(@order.checkout_session_id)
    puts "======================================================="
    puts refund = Stripe::Refund.create({payment_intent: @order_session['payment_intent']})
    puts "======================================================="
    
    # Annuler la commande Sendcloud
    @auth = {
      username: ENV["SENDCLOUD_API_KEY"],
      password: ENV["SENDCLOUD_SECRET_KEY"]
    }    
    puts cancel_parcel = HTTParty.post("https://panel.sendcloud.sc/api/v2/parcels/#{@order.sendcloud_order_id}/cancel", basic_auth: @auth)

    # Email a l'acheteur 
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
      'TemplateID'=> 2965281,
      'TemplateLanguage'=> true,
      'Subject'=> "La vente a été annulée",
      'Variables'=> {
        "prenom" => @order.user.first_name,
        "numero_commande" => @order.id,
        "modele_paire" => @order.sneaker.sneaker_db.name,
        "prix_de_vente" => @order.price_cents / 100
      }
    }])
    p buyer_mail.attributes['Messages']

    # Email au vendeur
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
      'TemplateID'=> 2965246,
      'TemplateLanguage'=> true,
      'Subject'=> "La vente a été annulée",
      'Variables'=> {
        "prenom" => @order.sneaker.user.first_name,
        "numero_commande" => @order.id,
        "modele_paire" => @order.sneaker.sneaker_db.name,
        "prix_de_vente" => @order.price_cents / 100
      }
    }])
    p seller_mail.attributes['Messages']
  end


  def cancel_sale_in_24h
    order_id = ForestLiana::ResourcesGetter.get_ids_from_request(params, 0).first

    @order = Order.find(order_id)

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
      'TemplateID'=> 2961653,
      'TemplateLanguage'=> true,
      'Subject'=> "Il te reste 1 jour pour envoyer ta paire ! ",
      'Variables'=> {
        "prenom" => @order.sneaker.user.first_name,
        "numero_commande" => @order.id,
        "modele_paire" => @order.sneaker.sneaker_db.name,
        "prix_de_vente" => @order.sneaker.price_cents / 100,
        "frais_de_livraison" => "5,05",
        "frais_authentification" => "0",
        "somme_vendeur" => (@order.sneaker.price_cents / 100) - 5.05,
        "lien_conseils_expédition" => "https://www.rockdontstock.com/faq"
      }
    }])
    p seller_mail.attributes['Messages']
  end
  
  def seller_send_package
    order_id = ForestLiana::ResourcesGetter.get_ids_from_request(params, 0).first
    @order = Order.find(order_id)

    @order.sneaker.update(state: 3)

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
      'TemplateID'=> 2965984,
      'TemplateLanguage'=> true,
      'Subject'=> "Paire envoyée ! 🚀",
      'Variables'=> {
        "prenom" => @order.sneaker.user.first_name,
        "numero_commande" => @order.id,
        "modele_paire" => @order.sneaker.sneaker_db.name,
        "prix_de_vente" => @order.sneaker.price_cents / 100,
        "frais_de_livraison" => "5,05",
        "frais_authentification" => "0", # OFFERT POUR LE MOMENT sinon -> ((@order.sneaker.price_cents / 100) * 0.12) / 2
        "somme_vendeur" => (@order.sneaker.price_cents / 100) - 5.05,
        "Lien" => "undefined"
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
      'TemplateID'=> 2966034,
      'TemplateLanguage'=> true,
      'Subject'=> "Paire envoyée ! ",
      'Variables'=> {
        "prenom" => @order.user.first_name,
        "compte_rockdontstock" => "https://www.rockdontstock.com/me",
        "numero_commande" => @order.id,
        "modele_paire" => @order.sneaker.sneaker_db.name,
        "prix_de_vente" => @order.sneaker.price_cents / 100,
        "frais_de_livraison" => @order.shipping_cost_cents / 100,
        "frais_authentification" => ((@order.sneaker.price_cents / 100) * 0.12) / 2,
        "prix_tot_paye_par_acheteur" => (@order.sneaker.price_cents / 100) + (((@sneaker.price_cents / 100) * 0.12) / 2) + (@order.shipping_cost_cents / 100)
      }
    }])
    p buyer_mail.attributes['Messages']
  end
end