class AddCheckOutSessionIdInAuthentication < ActiveRecord::Migration[6.1]
  def change
    add_column :authentications, :checkout_session_id, :string
  end
end
