class AddTokensToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :token_account, :string
    add_column :users, :token_person, :string
  end
end
