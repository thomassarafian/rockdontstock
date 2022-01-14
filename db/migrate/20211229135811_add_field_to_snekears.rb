class AddFieldToSnekears < ActiveRecord::Migration[6.1]
  def change
    add_column :sneakers, :selected, :boolean, default: :false
  end
end
