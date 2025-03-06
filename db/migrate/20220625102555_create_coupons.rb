class CreateCoupons < ActiveRecord::Migration[6.1]
  def change
    create_table :coupons do |t|
      t.string :name
      t.string :code
      t.boolean :active
      t.timestamps
    end
    
    add_reference :orders, :coupon, foreign_key: true

    Coupon.create!(
      name: "Frais d'authentifications offerts",
      code: "FRAISOFFERTS2022",
      active: true
    )
  end
end
