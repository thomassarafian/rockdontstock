class AddStatusToSneaker < ActiveRecord::Migration[6.1]
  def change
    add_column :sneakers, :status, :string
  end
end
