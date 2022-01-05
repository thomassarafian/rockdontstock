class AddFieldsToOrder < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :first_name, :string
    add_column :orders, :last_name, :string
    add_column :orders, :phone, :string
    add_column :orders, :delivery, :string
    add_column :orders, :address, :string
    add_column :orders, :city, :string
    add_column :orders, :zip_code, :string
    add_column :orders, :door_number, :string
  end
end
