class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.string :name
      t.string :purchase
      t.text :content
      t.integer :rating

      t.timestamps
    end

    Review.reset_column_information

    Review.create(
      name: "Thomas L.",
      purchase: "Pour l'achat d'une authentification Express",
      content: "Première fois que je fais authentifier une paire d'occasion, pas déçu Foncez si vous voulez éviter les mauvaises surprises!",
      rating: 5
    )
    Review.create(
      name: "Hugo B.",
      purchase: "Pour l'achat d'une authentification Rapide",
      content: "Déjà ma 4 ème authentification réalisée par la team Rock Don't Stock : comme toujours, c'est professionnel et très bien expliqué. Si vous souhaitez acheter une paire sans risque, foncez.",
      rating: 4
    )
    Review.create(
      name: "Maël H.",
      purchase: "Pour l'achat d'un guide à la demande",
      content: "Le guide est top, détaillé, argumenté et plutôt bien présenté ! C'est parfait pour Legit Check soi-même le modèle. Les points de checks sont assez simples à comprendre et les photos permettent de se faire une idée rapidement.",
      rating: 5
    )
    Review.create(
      name: "Cisse K.",
      purchase: "Pour l'achat d'un guide à la demande",
      content: "Super, grâce au guide, je viens d'apprendre que ma paire est fake… La prochaine fois, je ferai appel au service d'authentification ou je téléchargerai un guide avant de cop ma paire histoire d'éviter les mauvaises surprises. A part ça le guide est vraiment détaillé et super simple à comprendre.",
      rating: 4
    )
  end
end
