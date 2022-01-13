class AddColumnToSneaker < ActiveRecord::Migration[6.1]
  def change
    add_column :sneakers, :highlighted, :boolean, default: :false
  end
end
