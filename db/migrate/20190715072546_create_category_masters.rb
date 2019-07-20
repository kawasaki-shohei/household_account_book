class CreateCategoryMasters < ActiveRecord::Migration[5.2]
  def change
    create_table :category_masters do |t|
      t.string "name", null: false
      t.boolean "is_common", default: false
      t.timestamps
    end
  end
end
