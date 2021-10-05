class Forest::SneakersController < ForestLiana::SmartActionsController
  def validate_announcement
    sneaker_id = ForestLiana::ResourcesGetter.get_ids_from_request(params, 0).first

    @sneaker = Sneaker.find(sneaker_id)
    @sneaker.update(state: 1)
  
    variable = Mailjet::Send.create(messages: [{
      'From'=> {
        'Email'=> "elliot@rockdontstock.com",
        'Name'=> "Rock Don't Stock"
      },
      'To'=> [
        {
          'Email'=> @sneaker.user.email,
          'Name'=> @sneaker.user.first_name
        }
      ],
      'TemplateID'=> 2961491,
      'TemplateLanguage'=> true,
      'Subject'=> "Ta paire est en ligne !",
      'Variables'=> {
        "prenom" => @sneaker.user.first_name,
        "lien_annonce" => "https://www.rockdontstock.com/sneakers/#{@sneaker.id}",
        "modele_paire" => @sneaker.sneaker_db.name,
        "prix_de_vente" => @sneaker.price_cents / 100,
        "frais_de_livraison" => "6,30",
        "frais_authentification" => ((@sneaker.price_cents / 100) * 0.12) / 2,
        "somme_vendeur" => ((@sneaker.price_cents / 100) - 6.30) #- (((@sneaker.price_cents / 100) * 0.12) / 2)
      }
    }])
    p variable.attributes['Messages']
    
    render json: { 
      success: "L'annonce est en ligne et l'email a été envoyé au vendeur !"
    }
  end

  def reject_announcement_bad_criteria
    sneaker_id = ForestLiana::ResourcesGetter.get_ids_from_request(params, 0).first

    @sneaker = Sneaker.find(sneaker_id)
    @sneaker.update(state: -1)

    variable = Mailjet::Send.create(messages: [{
      'From'=> {
        'Email'=> "elliot@rockdontstock.com",
        'Name'=> "Rock Don't Stock"
      },
      'To'=> [
        {
          'Email'=> @sneaker.user.email,
          'Name'=> @sneaker.user.first_name
        }
      ],
      'TemplateID'=> 2961587,
      'TemplateLanguage'=> true,
      'Subject'=> "Erreur lors de la mise en ligne de ta paire 🧐",
      'Variables'=> {
        "prenom" => @sneaker.user.first_name,
        "modele_paire" => @sneaker.sneaker_db.name,
        "lien_faq" => "https://www.rockdontstock.com/faq"
      }
    }])
    p variable.attributes['Messages']

    render json: { 
      success: "L'annonce est refusée pour mauvais critères et l'email a été envoyé au vendeur !"
    }
  end
  
  def reject_announcement_bad_angles
    sneaker_id = ForestLiana::ResourcesGetter.get_ids_from_request(params, 0).first

    @sneaker = Sneaker.find(sneaker_id)
    @sneaker.update(state: -2)

    variable = Mailjet::Send.create(messages: [{
      'From'=> {
        'Email'=> "elliot@rockdontstock.com",
        'Name'=> "Rock Don't Stock"
      },
      'To'=> [
        {
          'Email'=> @sneaker.user.email,
          'Name'=> @sneaker.user.first_name
        }
      ],
      'TemplateID'=> 2961545,
      'TemplateLanguage'=> true,
      'Subject'=> "Erreur lors de la mise en ligne de ta paire 🧐",
      'Variables'=> {
        "prenom" => @sneaker.user.first_name,
        "modele_paire" => @sneaker.sneaker_db.name,
        "lien_annonce" => "https://www.rockdontstock.com/sneakers/#{@sneaker.id}",
        "lien_nouvelle_annonce" => "https://www.rockdontstock.com/sneakers/new",
        "lien_faq" => "https://www.rockdontstock.com/faq"
      }
    }])
    p variable.attributes['Messages']

    render json: { 
      success: "L'annonce est refusée pour mauvais angles et l'email a été envoyé au vendeur !"
    }
  end

  def reject_announcement_fake_sneakers
    sneaker_id = ForestLiana::ResourcesGetter.get_ids_from_request(params, 0).first

    @sneaker = Sneaker.find(sneaker_id)
    @sneaker.update(state: -3)
  
    variable = Mailjet::Send.create(messages: [{
      'From'=> {
        'Email'=> "elliot@rockdontstock.com",
        'Name'=> "Rock Don't Stock"
      },
      'To'=> [
        {
          'Email'=> @sneaker.user.email,
          'Name'=> @sneaker.user.first_name
        }
      ],
      'TemplateID'=> 3157438,
      'TemplateLanguage'=> true,
      'Subject'=> "Erreur lors de la mise en ligne de ta paire 🧐",
      'Variables'=> {
        "prenom" => @sneaker.user.first_name,
        "modele_paire" => @sneaker.sneaker_db.name,
        "lien_nouvelle_annonce" => "https://www.rockdontstock.com/sneakers/new"
      }
    }])
    p variable.attributes['Messages']
    
    render json: { 
      success: "L'annonce est refusée car la paire est fake et l'email a été envoyé au vendeur !"
    }
  end

  def validate_announcement_bad_photos
    sneaker_id = ForestLiana::ResourcesGetter.get_ids_from_request(params, 0).first

    @sneaker = Sneaker.find(sneaker_id)
    @sneaker.update(state: 1)
  
    variable = Mailjet::Send.create(messages: [{
      'From'=> {
        'Email'=> "elliot@rockdontstock.com",
        'Name'=> "Rock Don't Stock"
      },
      'To'=> [
        {
          'Email'=> @sneaker.user.email,
          'Name'=> @sneaker.user.first_name
        }
      ],
      'TemplateID'=> 3180072,
      'TemplateLanguage'=> true,
      'Subject'=> "Améliore ton annonce pour vendre ta paire au plus vite 🏃",
      'Variables'=> {
        "prenom" => @sneaker.user.first_name,
        "modele_paire" => @sneaker.sneaker_db.name,
        "lien_nouvelle_annonce" => "https://www.rockdontstock.com/sneakers/new"
      }
    }])
    p variable.attributes['Messages']
    
    render json: { 
      success: "L'annonce est validée malgré les photos :/ et l'email a été envoyé au vendeur !"
    }
  end

  def missing_information
    sneaker_id = ForestLiana::ResourcesGetter.get_ids_from_request(params, 0).first
    @sneaker = Sneaker.find(sneaker_id)
    
    variable = Mailjet::Send.create(messages: [{
      'From'=> {
        'Email'=> "elliot@rockdontstock.com",
        'Name'=> "Rock Don't Stock"
      },
      'To'=> [
        {
          'Email'=> @sneaker.user.email,
          'Name'=> @sneaker.user.first_name
        }
      ],
      'TemplateID'=> 3229327,
      'TemplateLanguage'=> true,
      'Subject'=> "Complète les informations manquantes afin que nous puissions valider ta paire ✍️ 🧐",
      'Variables'=> {
        "prenom" => @sneaker.user.first_name,
        "modele_paire" => @sneaker.sneaker_db.name
      }
    }])
    p variable.attributes['Messages']
  end
end
