class Forest::SneakersController < ForestLiana::SmartActionsController

  def set_as_day_selection
    selected_id = ForestLiana::ResourcesGetter.get_ids_from_request(params, 0).first

    Sneaker.find(selected_id).update(highlighted: true)

    # keep latest 3 as highlighted
    if Sneaker.highlighted.count > 3
      first_highlighted = Sneaker.highlighted.first
      first_highlighted&.update(highlighted: false)
    end

  end

  def set_as_home_selection
    selected_ids = ForestLiana::ResourcesGetter.get_ids_from_request(params, 0)
    
    selection = Sneaker.where(id: selected_ids)
    selection.update_all(selected: true)

    # keep latest 10 as selected 
    if Sneaker.selected.count > 10
      count = selection.count
      sneakers_to_remove = Sneaker.selected[0..count - 1]
      sneakers_to_remove = Sneaker.where(id: sneakers_to_remove.map(&:id))
      sneakers_to_remove.update_all(selected: false)
    end
  end

  def send_email_finish_announcement
    selected_ids = ForestLiana::ResourcesGetter.get_ids_from_request(params, 0)

    # we want to send reminder emails to ppl whose upload did not go through
    sneakers = Sneaker.where(id: selected_ids).where(status: "infos_ok")

    sneakers.each do |sneaker|
      next if sneaker.photos.count >= 6

      Mailjet::Send.create(messages: [{
        'From'=> {
          'Email'=> "elliot@rockdontstock.com",
          'Name'=> "Rock Don't Stock"
        },
        'To' => [{ 'Email' => sneaker.user.email, 'Name' => sneaker.user.full_name }],
        'TemplateID'=> 3522451,
        'TemplateLanguage'=> true,
        'Subject'=> "N'hésite pas à terminer ton annonce !",
        'Variables'=> {
          "prenom" => sneaker.user.first_name,
          "modele_paire" => sneaker.sneaker_db.name,
          "date_creation" => sneaker.created_at.strftime("%d/%m/%Y"),
          "lien" => sneaker_build_url(sneaker.id, sneaker.status)
        }
      }])
    end
  end

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
        "frais_de_livraison" => "5,05",
        "frais_authentification" => ((@sneaker.price_cents / 100) * 0.12) / 2,
        "somme_vendeur" => ((@sneaker.price_cents / 100) - 6.30) #- (((@sneaker.price_cents / 100) * 0.12) / 2)
      }
    }])
    p variable.attributes['Messages']
    
    Subscription.new(@sneaker.user).as_seller
    
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

    render json: {
      success: "L'annonce n'est pas en ligne et l'email a été envoyé au vendeur !"
    }
  end
end

