class RenameAttrInAuthentications < ActiveRecord::Migration[6.1]
  def change
    rename_column :authentications, :checkout_session_id, :paypal_order_id
  end
end
