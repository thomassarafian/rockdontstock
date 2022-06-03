class AddProductRefToAuth < ActiveRecord::Migration[6.1]
  def change
    add_reference :authentications, :product, foreign_key: true
  end
end
