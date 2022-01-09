class AddRelayToOrder < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :relay_address, :string
  end
end
