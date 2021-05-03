class AddStateToSneakers < ActiveRecord::Migration[6.1]
  def change
  	add_column :sneakers, :state, :integer
  end
end
