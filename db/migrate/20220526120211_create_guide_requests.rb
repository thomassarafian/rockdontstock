class CreateGuideRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :guide_requests do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :city
      t.date :date_of_birth
      t.boolean :newsletter, default: false

      t.string :payment_intent_id
      t.integer :payment_method
      t.integer :payment_status, default: 0
      
      t.belongs_to :guide

      t.timestamps
    end

    add_column :guides, :price_in_cents, :integer, default: 390
  end
end
