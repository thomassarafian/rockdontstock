class AddTwoSendcloudIdToOrders < ActiveRecord::Migration[6.1]
  def change
    rename_column :orders, :sendcloud_order_id, :sendcloud_order_id_seller
    add_column :orders, :sendcloud_order_id_buyer, :string
  end
end
