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
end
