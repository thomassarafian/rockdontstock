class AddpaymentStatusToOrder < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :payment_status, :integer, default: 0
  end
end
