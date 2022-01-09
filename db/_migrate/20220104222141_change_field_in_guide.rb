class ChangeFieldInGuide < ActiveRecord::Migration[6.1]
  def change
    remove_column :guides, :description, :text
    add_column :guides, :img_url, :string
  end
end
