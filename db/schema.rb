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

ActiveRecord::Schema.define(version: 20180510214332) do

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

  create_table "categories", force: :cascade do |t|
    t.string "kind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.boolean "common", default: false
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.integer "amount"
    t.date "date"
    t.string "note"
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

  create_table "partners", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "partner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["partner_id"], name: "index_partners_on_partner_id"
    t.index ["user_id"], name: "index_partners_on_user_id"
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
    t.string "note"
    t.bigint "category_id"
    t.bigint "user_id"
    t.boolean "both_flg", default: false
    t.integer "mypay"
    t.integer "partnerpay"
    t.integer "percent"
    t.index ["category_id"], name: "index_repeat_expenses_on_category_id"
    t.index ["user_id"], name: "index_repeat_expenses_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "badgets", "categories"
  add_foreign_key "badgets", "users"
  add_foreign_key "categories", "users"
  add_foreign_key "expenses", "repeat_expenses"
  add_foreign_key "partners", "users"
  add_foreign_key "partners", "users", column: "partner_id"
  add_foreign_key "pays", "users"
  add_foreign_key "repeat_expenses", "categories"
  add_foreign_key "repeat_expenses", "users"
end
