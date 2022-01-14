class EditAgeInAuthentication < ActiveRecord::Migration[6.1]
  def change
    remove_column :authentications, :age, :integer
    add_column :authentications, :date_of_birth, :date
  end
end
