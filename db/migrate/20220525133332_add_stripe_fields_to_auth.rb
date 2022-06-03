class AddStripeFieldsToAuth < ActiveRecord::Migration[6.1]
  def change
    add_column :authentications, :payment_intent_id, :string
    add_column :authentications, :payment_method, :integer
  end
end
