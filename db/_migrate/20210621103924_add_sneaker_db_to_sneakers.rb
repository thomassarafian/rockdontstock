class AddSneakerDbToSneakers < ActiveRecord::Migration[6.1]
  def change
    add_reference :sneakers, :sneaker_db, null: true, foreign_key: true
  end
end