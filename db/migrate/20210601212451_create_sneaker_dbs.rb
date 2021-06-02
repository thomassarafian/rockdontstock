class CreateSneakerDbs < ActiveRecord::Migration[6.1]
  def change
    create_table :sneaker_dbs do |t|
      t.string :name
      t.string :style
      t.string :coloris
      t.monetize :price, currency: { present: false }
      t.date :release_date
      t.string :category
      t.text :subcategory, array: true, default: []
      t.string :img_url

      t.timestamps
    end
  end
end
