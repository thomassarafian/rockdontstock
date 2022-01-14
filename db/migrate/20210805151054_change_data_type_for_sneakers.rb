class ChangeDataTypeForSneakers < ActiveRecord::Migration[6.1]
  def change
    change_column :sneakers, :size, :decimal
  end
end
