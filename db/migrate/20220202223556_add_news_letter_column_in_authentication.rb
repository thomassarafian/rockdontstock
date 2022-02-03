class AddNewsLetterColumnInAuthentication < ActiveRecord::Migration[6.1]
  def change
    add_column :authentications, :newsletter, :boolean, default: false
  end
end
