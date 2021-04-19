class CreateSneakers < ActiveRecord::Migration[6.1]
  def change
    create_table :sneakers do |t|
      t.string :name
      t.integer :size
      t.integer :condition
      t.string :box
      t.string :extras

      t.timestamps
    end
  end
end
