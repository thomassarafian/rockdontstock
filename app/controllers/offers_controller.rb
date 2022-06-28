class OffersController < ApplicationController
  before_action :find_sneaker
  before_action :find_offer, only: [:accept, :refuse]

  def new
    offer = current_user&.search_accepted_offer_on(@sneaker)
    @offer_price = offer&.amount
  end

  def create
    buyer = current_user
    seller = @sneaker.user

    offer = Offer.new(
      amount: offer_params[:amount],
      sneaker: @sneaker,
      user: buyer,
      status: "pending"
    )
    if offer.save

      # inform seller
      var = Mailjet::Send.create(messages: [{
        'From'=> {
          'Email'=> "elliot@rockdontstock.com",
          'Name'=> "Rock Don't Stock"
        },
        'To'=> [
          {
            'Email'=> seller.email,
            'Name'=> seller.first_name
          }
        ],
        'TemplateID'=> 4019021,
        'TemplateLanguage'=> true,
        'Subject'=> "Tu as reçu une nouvelle offre de prix",
        'Variables'=> {
          "prenom_vendeur" => seller.first_name,
          "prenom_acheteur" => buyer.first_name,
          "modele_paire" => @sneaker.sneaker_db.name,
          "initial_amount" => @sneaker.price.to_s,
          "offer_amount" => offer.amount.to_s,
          "offer_id" => offer.id.to_s
        }
      }])
      p var.attributes['Messages']
    else
    
    end
    flash[:notice] = "L'offre a bien été envoyée au vendeur !"
    redirect_to @sneaker
  end

  # TODO add token in mails
  def accept
    @offer.update!(status: "accepted")

    # inform buyer
    var = Mailjet::Send.create(messages: [{
      'From'=> {
        'Email'=> "elliot@rockdontstock.com",
        'Name'=> "Rock Don't Stock"
      },
      'To'=> [
        {
          'Email'=> @buyer.email,
          'Name'=> @buyer.first_name
        }
      ],
      'TemplateID'=> 4019065,
      'TemplateLanguage'=> true,
      'Subject'=> "Ton offre a été acceptée !",
      'Variables'=> {
        "prenom_vendeur" => @seller.first_name,
        "prenom_acheteur" => @buyer.first_name,
        "modele_paire" => @sneaker.sneaker_db.name,
        "initial_amount" => @sneaker.price.to_s,
        "offer_amount" => @offer.amount.to_s,
        "sneaker_id" => @sneaker.id.to_s
      }
    }])
    p var.attributes['Messages']
    flash[:notice] = "L'offre a bien été acceptée"
    redirect_to @sneaker
  end

  def refuse
    @offer.update(status: "refused")

    # inform buyer
    var = Mailjet::Send.create(messages: [{
      'From'=> {
        'Email'=> "elliot@rockdontstock.com",
        'Name'=> "Rock Don't Stock"
      },
      'To'=> [
        {
          'Email'=> @buyer.email,
          'Name'=> @buyer.first_name
        }
      ],
      'TemplateID'=> 4019111,
      'TemplateLanguage'=> true,
      'Subject'=> "Ton offre n'a pas été acceptée",
      'Variables'=> {
        "prenom_vendeur" => @seller.first_name,
        "prenom_acheteur" => @buyer.first_name,
        "modele_paire" => @sneaker.sneaker_db.name,
        "initial_amount" => @sneaker.price.to_s,
        "offer_amount" => @offer.amount.to_s,
        "sneaker_id" => @sneaker.id.to_s
      }
    }])
    p var.attributes['Messages']
    flash[:notice] = "L'offre a bien été refusée"
    redirect_to @sneaker
  end

  private

  def offer_params
    params.permit(:amount, :sneaker_id)
  end

  def find_sneaker
    @sneaker = Sneaker.find(offer_params[:sneaker_id])
  end

  def find_offer
    @offer = Offer.find(params[:id])
    @buyer = @offer.user
    @seller = @offer.sneaker.user
  end
end
