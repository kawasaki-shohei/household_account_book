class AddCommonToCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :common, :boolean, default: false
  end
end
