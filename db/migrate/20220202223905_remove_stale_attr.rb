class RemoveStaleAttr < ActiveRecord::Migration[6.1]
  def change
    remove_column :sneaker_dbs, :subcategory
  end
end
