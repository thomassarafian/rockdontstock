class RemoveCheckoutFromOrder < ActiveRecord::Migration[6.1]
  def change
    remove_column :orders, :checkout_session_id, :string
  end
end
