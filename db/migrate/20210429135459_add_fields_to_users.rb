class AddFieldsToUsers < ActiveRecord::Migration[6.1]
  def change
  	add_column :users, :date_of_birth, :date
    add_column :users, :line1, :string
  	add_column :users, :city, :string
  	add_column :users, :postal_code, :string
  end
end
