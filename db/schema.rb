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

ActiveRecord::Schema.define(version: 20161114181042) do

  create_table "ali_reviews", force: :cascade do |t|
    t.string   "productId",       limit: 45
    t.text     "username",        limit: 65535
    t.text     "user_country",    limit: 65535
    t.integer  "user_order_rate", limit: 4
    t.text     "user_order_info", limit: 65535
    t.text     "review_date",     limit: 65535
    t.text     "review_content",  limit: 65535
    t.text     "review_photos",   limit: 65535
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "is_empty",        limit: 3
  end

  create_table "categories", force: :cascade do |t|
    t.text   "name", limit: 65535
    t.string "icon", limit: 45
  end

  add_index "categories", ["id"], name: "id_UNIQUE", unique: true, using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "author",             limit: 4
    t.text     "page",               limit: 65535
    t.text     "content",            limit: 65535
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
    t.string   "accepted",           limit: 45
  end

  create_table "hot_products", force: :cascade do |t|
    t.string   "productId",            limit: 45
    t.text     "productTitle",         limit: 65535
    t.text     "productUrl",           limit: 65535
    t.text     "promotionUrl",         limit: 65535
    t.text     "imageUrl",             limit: 65535
    t.string   "originalPrice",        limit: 45
    t.string   "salePrice",            limit: 45
    t.float    "discount",             limit: 24
    t.integer  "lotNum",               limit: 4
    t.string   "thirtydaysCommission", limit: 45
    t.string   "packageType",          limit: 45
    t.float    "evaluateScore",        limit: 24
    t.date     "validTime"
    t.integer  "quanity_sold",         limit: 4
    t.float    "commision",            limit: 24
    t.integer  "volume",               limit: 4
    t.text     "aff_url",              limit: 65535
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "category",             limit: 4,     default: 50, null: false
    t.integer  "subcategory",          limit: 4
    t.integer  "sub_subcategory",      limit: 4
    t.text     "storeName",            limit: 65535
    t.text     "storeUrl",             limit: 65535
  end

  create_table "items", force: :cascade do |t|
    t.string   "productId",            limit: 45
    t.text     "productTitle",         limit: 65535
    t.text     "productDescription",   limit: 65535
    t.text     "productUrl",           limit: 65535
    t.text     "promotionUrl",         limit: 65535
    t.text     "imageUrl",             limit: 65535
    t.string   "originalPrice",        limit: 45
    t.float    "salePrice",            limit: 24
    t.text     "storeName",            limit: 65535
    t.text     "storeUrl",             limit: 65535
    t.float    "discount",             limit: 24
    t.integer  "lotNum",               limit: 4
    t.string   "thirtydaysCommission", limit: 45
    t.string   "packageType",          limit: 45
    t.float    "evaluateScore",        limit: 24
    t.date     "validTime"
    t.integer  "quanity_sold",         limit: 4
    t.float    "commision",            limit: 24
    t.integer  "volume",               limit: 4
    t.text     "aff_url",              limit: 65535
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "category",             limit: 4,     default: 50, null: false
    t.integer  "subcategory",          limit: 4
    t.integer  "sub_subcategory",      limit: 4
    t.string   "is_hot",               limit: 3
    t.string   "is_approved",          limit: 3
  end

  create_table "reviews", force: :cascade do |t|
    t.text     "title",              limit: 65535
    t.text     "short_description",  limit: 65535
    t.text     "long_description",   limit: 65535
    t.text     "keywords",           limit: 65535
    t.text     "promoted",           limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "item_id",            limit: 4
    t.string   "cover_file_name",    limit: 255
    t.string   "cover_content_type", limit: 255
    t.integer  "cover_file_size",    limit: 4
    t.datetime "cover_updated_at"
    t.integer  "author",             limit: 4
  end

  create_table "subcategories", force: :cascade do |t|
    t.integer "parent", limit: 4
    t.text    "name",   limit: 65535
  end

  create_table "users", force: :cascade do |t|
    t.text     "nickname",            limit: 65535
    t.text     "password",            limit: 65535
    t.text     "password_digest",     limit: 65535
    t.text     "name",                limit: 65535
    t.text     "surname",             limit: 65535
    t.text     "description",         limit: 65535
    t.text     "email",               limit: 65535
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "avatar_file_name",    limit: 255
    t.string   "avatar_content_type", limit: 255
    t.integer  "avatar_file_size",    limit: 4
    t.datetime "avatar_updated_at"
  end

end
