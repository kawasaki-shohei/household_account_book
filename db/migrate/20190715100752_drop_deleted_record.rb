class DropDeletedRecord < ActiveRecord::Migration[5.2]
  def up
    drop_table :deleted_records
  end

  def down
    create_table "deleted_records", force: :cascade do |t|
      t.bigint "deleted_by"
      t.string "table_name"
      t.text "record_meta", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["deleted_by"], name: "index_deleted_records_on_deleted_by"
    end
  end
end
