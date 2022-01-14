class CreateAuthentications < ActiveRecord::Migration[6.1]
  def change
    create_table :authentications do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :city
      t.integer :age

      t.timestamps
    end
  end
end
