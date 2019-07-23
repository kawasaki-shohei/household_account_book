class AddIsPreviewUserToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_preview_user, :boolean, default: false
  end
end
