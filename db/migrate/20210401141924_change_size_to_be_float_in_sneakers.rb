class ChangeSizeToBeFloatInSneakers < ActiveRecord::Migration[6.1]
  def change
  	change_column :sneakers, :size, :float
  end
end
