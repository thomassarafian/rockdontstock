class AddSendcloudIdToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :sendcloud_order_id, :string
  end
end
