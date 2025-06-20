ActiveRecord::Schema.define(version: 2025_06_20_000000) do

  create_table "countries", primary_key: "code", force: :cascade do |t|
    t.string "name"
    t.string "continent_name"
  end

  create_table "users", force: :cascade do |t|
    t.integer "id", null: false
    t.string "full_name"
    t.datetime "created_at"
    t.integer "country_code"
  end

  add_index "users", ["id"], name: "users_pkey", unique: true

  create_table "ecommerce_merchants", primary_key: %i[id country_code], force: :cascade do |t|
    t.integer "id", null: false
    t.integer "country_code"
    t.string "merchant_name"
    t.string "created at"
    t.integer "admin_id", null: false
  end

  add_foreign_key "ecommerce_merchants", "users", column: "admin_id"

  create_table "ecommerce_orders", force: :cascade do |t|
    t.integer "id", null: false
    t.integer "user_id", null: false
    t.string "status"
    t.string "created_at", comment: "When order created"
  end

  add_index "ecommerce_orders", ["user_id"], unique: true, name: "index_orders_on_user_id"
  add_foreign_key "ecommerce_orders", "users", column: "user_id", name: "user_orders"

  create_table "ecommerce_order_items", primary_key: %i[order_id product_id], force: :cascade do |t|
    t.integer "order_id", null: false
    t.integer "product_id", null: false
    t.integer "quantity", default: 1
  end

  add_foreign_key "ecommerce_order_items", "ecommerce_orders", column: "order_id"
  add_foreign_key "ecommerce_order_items", "ecommerce_products", column: "product_id"

  create_table "ecommerce_products", force: :cascade do |t|
    t.integer "id", null: false
    t.string "name"
    t.integer "merchant_id", null: false
    t.integer "price"
    t.string "status"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }
  end

  add_index "ecommerce_products", ["id"], unique: true
  add_index "ecommerce_products", ["merchant_id", "status"], name: "product_status"
  add_foreign_key "ecommerce_products", "ecommerce_merchants", column: "merchant_id"

  create_table "ecommerce_product_tags", force: :cascade do |t|
    t.integer "id", null: false
    t.string "name"
  end

  # Join table for many-to-many relationship (not explicitly defined in DBML)
  create_table "ecommerce_product_tags_products", id: false, force: :cascade do |t|
    t.integer "product_tag_id", null: false
    t.integer "product_id", null: false
  end

  add_index "ecommerce_product_tags_products", ["product_tag_id", "product_id"], name: "index_product_tags_products", unique: true
  add_foreign_key "ecommerce_product_tags_products", "ecommerce_product_tags", column: "product_tag_id"
  add_foreign_key "ecommerce_product_tags_products", "ecommerce_products", column: "product_id"

  create_table "ecommerce_merchant_periods", force: :cascade do |t|
    t.integer "id", null: false
    t.integer "merchant_id"
    t.integer "country_code"
    t.datetime "start_date"
    t.datetime "end_date"
  end

  # Emulate enum with comment (Rails doesn't support enums in schema.rb)
  # Enum: ecommerce.products_status = [out_of_stock, in_stock, running_low]
  # Note: running_low = 'less than 20'

end
