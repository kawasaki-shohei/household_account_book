class RenameIsPreviewUserToIsDemoUserInUsers < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :is_preview_user, :is_demo_user
  end
end
