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

ActiveRecord::Schema.define(version: 2019_11_03_075519) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
  end

  create_table "balances", force: :cascade do |t|
    t.bigint "user_id"
    t.string "period"
    t.integer "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "period"], name: "index_balances_on_user_id_and_period", unique: true
    t.index ["user_id"], name: "index_balances_on_user_id"
  end

  create_table "budgets", force: :cascade do |t|
    t.integer "amount"
    t.bigint "user_id"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_budgets_on_category_id"
    t.index ["user_id"], name: "index_budgets_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.boolean "is_common", default: false
    t.bigint "category_master_id"
    t.index ["category_master_id"], name: "index_categories_on_category_master_id"
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "category_masters", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "is_common", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "couples", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "partner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["partner_id"], name: "index_couples_on_partner_id", unique: true
    t.index ["user_id"], name: "index_couples_on_user_id", unique: true
  end

  create_table "deposits", force: :cascade do |t|
    t.bigint "user_id"
    t.boolean "is_withdrawn", default: false
    t.integer "amount", null: false
    t.date "date", null: false
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
    t.boolean "is_for_both", default: false
    t.integer "mypay"
    t.integer "partnerpay"
    t.integer "percent", limit: 2, default: 0, null: false
    t.bigint "repeat_expense_id"
    t.index ["repeat_expense_id"], name: "index_expenses_on_repeat_expense_id"
  end

  create_table "incomes", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "amount"
    t.date "date"
    t.string "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_incomes_on_user_id"
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
    t.integer "amount"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date"
    t.string "memo"
    t.index ["user_id"], name: "index_pays_on_user_id"
  end

  create_table "repeat_expenses", force: :cascade do |t|
    t.integer "amount"
    t.date "start_date"
    t.date "end_date"
    t.integer "repeat_day"
    t.string "memo"
    t.bigint "category_id"
    t.bigint "user_id"
    t.boolean "is_for_both", default: false
    t.integer "mypay"
    t.integer "partnerpay"
    t.integer "percent", limit: 2, default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "item_id", null: false
    t.integer "item_sub_id", null: false
    t.integer "updated_period", limit: 2, default: 0, null: false
    t.datetime "deleted_at"
    t.index ["category_id"], name: "index_repeat_expenses_on_category_id"
    t.index ["deleted_at"], name: "index_repeat_expenses_on_deleted_at"
    t.index ["user_id", "item_id", "item_sub_id"], name: "index_repeat_expenses_on_user_id_and_item_id_and_item_sub_id", unique: true
    t.index ["user_id"], name: "index_repeat_expenses_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "allow_share_own", default: false
    t.boolean "is_demo_user", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "balances", "users"
  add_foreign_key "budgets", "categories"
  add_foreign_key "budgets", "users"
  add_foreign_key "categories", "category_masters"
  add_foreign_key "categories", "users"
  add_foreign_key "couples", "users"
  add_foreign_key "couples", "users", column: "partner_id"
  add_foreign_key "deposits", "users"
  add_foreign_key "expenses", "repeat_expenses"
  add_foreign_key "incomes", "users"
  add_foreign_key "notifications", "notification_messages"
  add_foreign_key "notifications", "users"
  add_foreign_key "pays", "users"
  add_foreign_key "repeat_expenses", "categories"
  add_foreign_key "repeat_expenses", "users"

  create_view "latest_repeat_expenses", sql_definition: <<-SQL
      SELECT repeat_expenses_a.id,
      repeat_expenses_a.amount,
      repeat_expenses_a.start_date,
      repeat_expenses_a.end_date,
      repeat_expenses_a.repeat_day,
      repeat_expenses_a.memo,
      repeat_expenses_a.category_id,
      repeat_expenses_a.user_id,
      repeat_expenses_a.is_for_both,
      repeat_expenses_a.mypay,
      repeat_expenses_a.partnerpay,
      repeat_expenses_a.percent,
      repeat_expenses_a.created_at,
      repeat_expenses_a.updated_at,
      repeat_expenses_a.item_id,
      repeat_expenses_a.item_sub_id,
      repeat_expenses_a.updated_period,
      repeat_expenses_a.deleted_at
     FROM (repeat_expenses repeat_expenses_a
       JOIN ( SELECT repeat_expenses.item_id,
              repeat_expenses.user_id,
              max(repeat_expenses.item_sub_id) AS max_item_sub_id
             FROM repeat_expenses
            GROUP BY repeat_expenses.user_id, repeat_expenses.item_id) repeat_expenses_b ON (((repeat_expenses_a.user_id = repeat_expenses_b.user_id) AND (repeat_expenses_a.item_id = repeat_expenses_b.item_id) AND (repeat_expenses_a.item_sub_id = repeat_expenses_b.max_item_sub_id))))
    WHERE (repeat_expenses_a.deleted_at IS NULL);
  SQL
end
