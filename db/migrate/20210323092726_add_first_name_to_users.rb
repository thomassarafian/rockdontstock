# class RenameUserFirstnameToFirstName < ActiveRecord::Migration[6.1]
#   def change
# 	rename_column :users, :firstname, :first_name
#   end
# end

class AddFirstNameToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :first_name, :string
  end
end
