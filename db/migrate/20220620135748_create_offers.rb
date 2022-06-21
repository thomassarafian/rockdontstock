class CreateOffers < ActiveRecord::Migration[6.1]
  def change
    create_table :offers do |t|
      t.integer :amount_cents
      t.integer :status
      t.belongs_to :user
      t.belongs_to :sneaker

      t.timestamps
    end
  end
end
