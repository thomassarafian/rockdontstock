class AddFieldToGuide < ActiveRecord::Migration[6.1]
  def change
    add_column :guides, :sendinblue_list_id, :integer
  end
end
