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

ActiveRecord::Schema.define(version: 2020_06_25_013832) do

  create_table "areas", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ancestry"
    t.index ["ancestry"], name: "index_categories_on_ancestry"
    t.index ["name"], name: "index_categories_on_name"
  end

  create_table "postages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "text", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.text "text", null: false
    t.integer "price", null: false
    t.string "brand"
    t.bigint "category_id", null: false
    t.bigint "size_id"
    t.bigint "status_id"
    t.bigint "postage_id", null: false
    t.bigint "area_id", null: false
    t.bigint "shipping_date_id", null: false
    t.boolean "purchase", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["area_id"], name: "index_products_on_area_id"
    t.index ["brand"], name: "index_products_on_brand"
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["name"], name: "index_products_on_name"
    t.index ["postage_id"], name: "index_products_on_postage_id"
    t.index ["price"], name: "index_products_on_price"
    t.index ["shipping_date_id"], name: "index_products_on_shipping_date_id"
    t.index ["size_id"], name: "index_products_on_size_id"
    t.index ["status_id"], name: "index_products_on_status_id"
  end

  create_table "shipping_dates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "text", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sizes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "text", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "statuses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "text", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "products", "areas"
  add_foreign_key "products", "categories"
  add_foreign_key "products", "postages"
  add_foreign_key "products", "shipping_dates"
  add_foreign_key "products", "sizes"
  add_foreign_key "products", "statuses"
end
