# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160324123807) do

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "price"
    t.integer  "subcategory_id"
    t.integer  "menu_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "items", ["menu_id"], name: "index_items_on_menu_id"
  add_index "items", ["subcategory_id"], name: "index_items_on_subcategory_id"

  create_table "menus", force: :cascade do |t|
    t.date     "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_menu_items", force: :cascade do |t|
    t.integer  "quantity"
    t.string   "details"
    t.integer  "order_id"
    t.integer  "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "order_menu_items", ["item_id"], name: "index_order_menu_items_on_item_id"
  add_index "order_menu_items", ["order_id"], name: "index_order_menu_items_on_order_id"

  create_table "orders", force: :cascade do |t|
    t.datetime "time"
    t.integer  "table_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "orders", ["table_id"], name: "index_orders_on_table_id"
  add_index "orders", ["user_id"], name: "index_orders_on_user_id"

  create_table "subcategories", force: :cascade do |t|
    t.string   "name"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "subcategories", ["category_id"], name: "index_subcategories_on_category_id"

  create_table "tables", force: :cascade do |t|
    t.integer  "number"
    t.integer  "sum"
    t.boolean  "payment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.boolean  "manager",    default: false
    t.string   "email",                      null: false
    t.string   "password",                   null: false
    t.string   "name"
    t.string   "telephone"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "salt"
  end

end
