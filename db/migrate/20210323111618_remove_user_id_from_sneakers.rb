class RemoveUserIdFromSneakers < ActiveRecord::Migration[6.1]
  def change
    remove_column :sneakers, :user_id, :bigint
  end
end
