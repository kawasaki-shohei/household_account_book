# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_01_27_102436) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "badgets", force: :cascade do |t|
    t.integer "amount"
    t.bigint "user_id"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_badgets_on_category_id"
    t.index ["user_id"], name: "index_badgets_on_user_id"
  end

  create_table "balances", force: :cascade do |t|
    t.bigint "user_id"
    t.string "month"
    t.integer "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "month"], name: "index_balances_on_user_id_and_month", unique: true
    t.index ["user_id"], name: "index_balances_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "kind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.boolean "common", default: false
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "deleted_records", force: :cascade do |t|
    t.bigint "deleted_by"
    t.string "table_name"
    t.text "record_meta", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_by"], name: "index_deleted_records_on_deleted_by"
  end

  create_table "deposits", force: :cascade do |t|
    t.bigint "user_id"
    t.boolean "is_withdrawn", default: false
    t.integer "amount", null: false
    t.datetime "date", null: false
    t.string "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_deposits_on_user_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.integer "amount"
    t.date "date"
    t.string "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "category_id"
    t.integer "user_id"
    t.boolean "both_flg", default: false
    t.integer "mypay"
    t.integer "partnerpay"
    t.integer "percent"
    t.bigint "repeat_expense_id"
    t.index ["repeat_expense_id"], name: "index_expenses_on_repeat_expense_id"
  end

  create_table "notification_messages", force: :cascade do |t|
    t.string "func"
    t.string "act"
    t.integer "msg_id"
    t.index ["msg_id"], name: "index_notification_messages_on_msg_id", unique: true
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "notification_message_id"
    t.integer "notified_by_id"
    t.text "record_meta", null: false
    t.boolean "read_flg", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notification_message_id"], name: "index_notifications_on_notification_message_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "pays", force: :cascade do |t|
    t.integer "pamount"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date"
    t.string "memo"
    t.index ["user_id"], name: "index_pays_on_user_id"
  end

  create_table "repeat_expenses", force: :cascade do |t|
    t.integer "amount"
    t.date "s_date"
    t.date "e_date"
    t.integer "r_date"
    t.string "memo"
    t.bigint "category_id"
    t.bigint "user_id"
    t.boolean "both_flg", default: false
    t.integer "mypay"
    t.integer "partnerpay"
    t.integer "percent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_repeat_expenses_on_category_id"
    t.index ["user_id"], name: "index_repeat_expenses_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "allow_share_own", default: false
    t.bigint "partner_id"
    t.boolean "sys_admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["partner_id"], name: "index_users_on_partner_id", unique: true
  end

  create_table "wants", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.boolean "bought_flg", default: false
    t.text "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_wants_on_user_id"
  end

  add_foreign_key "badgets", "categories"
  add_foreign_key "badgets", "users"
  add_foreign_key "balances", "users"
  add_foreign_key "categories", "users"
  add_foreign_key "deleted_records", "users", column: "deleted_by"
  add_foreign_key "deposits", "users"
  add_foreign_key "expenses", "repeat_expenses"
  add_foreign_key "notifications", "notification_messages"
  add_foreign_key "notifications", "users"
  add_foreign_key "pays", "users"
  add_foreign_key "repeat_expenses", "categories"
  add_foreign_key "repeat_expenses", "users"
  add_foreign_key "users", "users", column: "partner_id"
  add_foreign_key "wants", "users"
end
