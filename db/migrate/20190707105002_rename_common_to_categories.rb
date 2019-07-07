class RenameCommonToCategories < ActiveRecord::Migration[5.2]
  def change
    rename_column :categories, :common, :is_common
  end
end
