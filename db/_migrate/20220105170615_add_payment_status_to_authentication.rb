class AddPaymentStatusToAuthentication < ActiveRecord::Migration[6.1]
  def change
    add_column :authentications, :payment_status, :integer, default: 0
  end
end
