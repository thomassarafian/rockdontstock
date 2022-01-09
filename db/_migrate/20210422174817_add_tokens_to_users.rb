class AddTokensToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :token_account, :string
    add_column :users, :token_person, :string
    add_column :users, :stripe_account_id, :string
    add_column :users, :person_id, :string
    add_column :users, :customer_id, :string

  	add_index :users, :stripe_account_id, unique: true
  end
end
