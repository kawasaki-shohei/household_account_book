class DropWants < ActiveRecord::Migration[5.2]
  def up
    drop_table :wants
  end

  def down
    create_table "wants", force: :cascade do |t|
      t.bigint "user_id"
      t.string "name"
      t.boolean "bought_flg", default: false
      t.text "memo"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["user_id"], name: "index_wants_on_user_id"
    end
  end
end
