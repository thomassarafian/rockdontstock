class AddSlugToSneakers < ActiveRecord::Migration[6.1]
  def change
    add_column :sneakers, :slug, :string
    add_index :sneakers, :slug, unique: true
  end
end
