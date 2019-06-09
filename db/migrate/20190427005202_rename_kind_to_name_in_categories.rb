class RenameKindToNameInCategories < ActiveRecord::Migration[5.2]
  def change
    rename_column :categories, :kind, :name
  end
end
