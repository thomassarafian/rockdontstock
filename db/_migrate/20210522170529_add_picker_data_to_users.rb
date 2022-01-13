class AddPickerDataToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :picker_data, :json
  end
end
