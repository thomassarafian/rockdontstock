class RemoveSerialNumberFromSneakers < ActiveRecord::Migration[6.1]
  def change
    remove_column :sneakers, :serial_number, :string
  end
end
