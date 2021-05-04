class AddIdsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :ids, :json
  end
end
