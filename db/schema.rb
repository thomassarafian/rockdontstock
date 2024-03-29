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

ActiveRecord::Schema.define(version: 2022_06_03_112514) do

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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "payment_status", default: 0
    t.string "paypal_order_id"
    t.date "date_of_birth"
    t.boolean "newsletter", default: false
    t.bigint "product_id"
    t.string "payment_intent_id"
    t.integer "payment_method"
    t.index ["product_id"], name: "index_authentications_on_product_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "guide_requests", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "city"
    t.date "date_of_birth"
    t.boolean "newsletter", default: false
    t.string "payment_intent_id"
    t.integer "payment_method"
    t.integer "payment_status", default: 0
    t.bigint "guide_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["guide_id"], name: "index_guide_requests_on_guide_id"
  end

  create_table "guides", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "img_url"
    t.integer "sendinblue_list_id"
    t.integer "price_in_cents", default: 390
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
    t.bigint "user_id", null: false
    t.bigint "sneaker_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "sendcloud_order_id_seller"
    t.string "sendcloud_order_id_buyer"
    t.string "payment_intent_id"
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "delivery"
    t.string "address"
    t.string "city"
    t.string "zip_code"
    t.string "door_number"
    t.integer "payment_status", default: 0
    t.integer "payment_method"
    t.integer "shipping_fee_cents", default: 0, null: false
    t.integer "service_fee_cents", default: 0, null: false
    t.integer "total_price_cents", default: 0, null: false
    t.string "relay_address"
    t.index ["sneaker_id"], name: "index_orders_on_sneaker_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "price_in_cents"
    t.string "li1"
    t.string "li2"
    t.string "li3"
    t.string "li4"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.string "name"
    t.string "purchase"
    t.text "content"
    t.integer "rating"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "sneaker_dbs", force: :cascade do |t|
    t.string "name"
    t.string "style"
    t.string "coloris"
    t.integer "price_cents", default: 0, null: false
    t.date "release_date"
    t.string "category"
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
    t.string "status"
    t.string "slug"
    t.boolean "selected", default: false
    t.boolean "highlighted", default: false
    t.datetime "selected_at"
    t.datetime "highlighted_at"
    t.index ["slug"], name: "index_sneakers_on_slug", unique: true
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
    t.integer "age"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["stripe_account_id"], name: "index_users_on_stripe_account_id", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "authentications", "products"
  add_foreign_key "items", "orders"
  add_foreign_key "items", "users"
  add_foreign_key "orders", "sneakers"
  add_foreign_key "orders", "users"
  add_foreign_key "sneakers", "sneaker_dbs"
  add_foreign_key "sneakers", "users"
end
