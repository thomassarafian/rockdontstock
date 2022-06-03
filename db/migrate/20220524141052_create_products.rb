class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.integer :price_in_cents
      t.string :li1
      t.string :li2
      t.string :li3
      t.string :li4

      t.timestamps
    end

    Product.reset_column_information

    Product.create!(
      name: 'Basique',
      description: "Bénéficie de l'avis d'experts et reçois ton guide complet en 2 jours.",
      price_in_cents: 790,
      li1: "Résultats en 48H",
      li2: "4 points d'authentification par guide",
      li3: "Guide complet offert"
    )
    Product.create!(
      name: 'Rapide',
      description: "Sécurise ton achat en ligne avec une expertise solide dans la journée.",
      price_in_cents: 1290,
      li1: "Résultats en 12H",
      li2: "5 points d'authentification par guide",
      li3: "Idéal pour résoudre les litiges",
      li4: "Guide complet offert"
    )
    Product.create!(
      name: 'Express',
      description: "Pas le temps d'attendre ? Notre analyse complète en moins de 3 heures",
      price_in_cents: 1790,
      li1: "Résultats en 3H seulement",
      li2: "5 points d'authentification par guide",
      li3: "Idéal pour résoudre les litiges",
      li4: "Guide complet + 1 guide générique"
    )
  end
end
