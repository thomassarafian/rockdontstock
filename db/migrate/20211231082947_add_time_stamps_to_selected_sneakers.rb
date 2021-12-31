class AddTimeStampsToSelectedSneakers < ActiveRecord::Migration[6.1]
  def change
    add_column :sneakers, :selected_at, :datetime
    add_column :sneakers, :highlighted_at, :datetime
  end
end
