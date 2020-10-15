# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

<<<<<<< HEAD
ActiveRecord::Schema.define(version: 2020_10_13_183836) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
=======
ActiveRecord::Schema.define(version: 2020_10_15_130837) do
>>>>>>> Added all changes made in the lesson on models, except last practice

  create_table "orders", force: :cascade do |t|
    t.string "name"
    t.integer "status"
    t.integer "cost"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.json "options"
    t.integer "user_id", null: false
    t.index ["cost"], name: "index_orders_on_cost"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

<<<<<<< HEAD
=======
  create_table "orders_tags", id: false, force: :cascade do |t|
    t.integer "order_id", null: false
    t.integer "tag_id", null: false
  end

  create_table "passport_data", force: :cascade do |t|
    t.integer "series"
    t.integer "number"
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_passport_data_on_user_id"
  end

>>>>>>> Added all changes made in the lesson on models, except last practice
  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "surname"
    t.integer "balans"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "orders", "users"
  add_foreign_key "passport_data", "users"
end
