# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_12_08_153822) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "authentications", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "city"
    t.integer "age"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "items", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "order_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_id"], name: "index_items_on_order_id"
    t.index ["user_id"], name: "index_items_on_user_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "state"
    t.string "sneaker_name"
    t.integer "price_cents", default: 0, null: false
    t.string "checkout_session_id"
    t.bigint "user_id", null: false
    t.bigint "sneaker_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "shipping_cost_cents", default: 0, null: false
    t.integer "insurance_cents", default: 0, null: false
    t.integer "service_cents", default: 0, null: false
    t.string "sendcloud_order_id_seller"
    t.string "sendcloud_order_id_buyer"
    t.index ["sneaker_id"], name: "index_orders_on_sneaker_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "sneaker_dbs", force: :cascade do |t|
    t.string "name"
    t.string "style"
    t.string "coloris"
    t.integer "price_cents", default: 0, null: false
    t.date "release_date"
    t.string "category"
    t.text "subcategory", default: [], array: true
    t.string "img_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "sneakers", force: :cascade do |t|
    t.string "name"
    t.decimal "size"
    t.integer "condition"
    t.string "box"
    t.string "extras"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.integer "price_cents", default: 0, null: false
    t.integer "state"
    t.bigint "sneaker_db_id"
    t.index ["sneaker_db_id"], name: "index_sneakers_on_sneaker_db_id"
    t.index ["user_id"], name: "index_sneakers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name"
    t.string "last_name"
    t.string "provider"
    t.string "uid"
    t.string "picture_url"
    t.string "token"
    t.datetime "token_expiry"
    t.string "token_account"
    t.string "token_person"
    t.string "stripe_account_id"
    t.string "person_id"
    t.string "customer_id"
    t.date "date_of_birth"
    t.string "line1"
    t.string "city"
    t.string "postal_code"
    t.string "phone"
    t.string "iban"
    t.json "picker_data"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["stripe_account_id"], name: "index_users_on_stripe_account_id", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "items", "orders"
  add_foreign_key "items", "users"
  add_foreign_key "orders", "sneakers"
  add_foreign_key "orders", "users"
  add_foreign_key "sneakers", "sneaker_dbs"
  add_foreign_key "sneakers", "users"
end
