class OffersController < ApplicationController
  before_action :find_sneaker
  before_action :find_offer, only: [:accept, :refuse]

  def new
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
      Mailjet::Send.create(messages: [{
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
          "initial_amount" => @sneaker.price,
          "offer_amount" => offer.amount,
          "offer_id" => offer.id
        }
      }])
    else
    
    end
  end

  def accept
    @offer.update(status: "accepted")

    # inform buyer
    Mailjet::Send.create(messages: [{
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
        "initial_amount" => @sneaker.price,
        "offer_amount" => @offer.amount,
        "offer_id" => @offer.id
      }
    }])
  end

  def refuse
    @offer.update(status: "refused")

    # inform buyer
    Mailjet::Send.create(messages: [{
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
        "initial_amount" => @sneaker.price,
        "offer_amount" => @offer.amount
      }
    }])
  end

  private

  def offer_params
    params.require(:offer).permit(:amount)
  end

  def find_sneaker
    @sneaker = Sneaker.find(params[:sneaker_id])
  end

  def find_offer
    @offer = Offer.find(params[:id])
    @buyer = @offer.user
    @seller = @offer.sneaker.user
  end
end
