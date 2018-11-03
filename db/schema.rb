# frozen_string_literal: true

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

ActiveRecord::Schema.define(version: 20_180_604_142_011) do
  create_table 'ali_reviews', id: :integer, force: :cascade do |t|
    t.string 'productId', limit: 45
    t.text 'username'
    t.text 'user_country'
    t.integer 'user_order_rate'
    t.text 'user_order_info'
    t.text 'review_date'
    t.text 'review_content'
    t.text 'review_photos'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'is_empty', limit: 3
  end

  create_table 'categories', id: :integer, default: nil, force: :cascade do |t|
    t.text 'name'
    t.string 'icon', limit: 45
    t.index ['id'], name: 'id_UNIQUE', unique: true
  end

  create_table 'ckeditor_assets', id: :integer, force: :cascade do |t|
    t.string 'data_file_name', null: false
    t.string 'data_content_type'
    t.integer 'data_file_size'
    t.string 'data_fingerprint'
    t.integer 'assetable_id'
    t.string 'assetable_type', limit: 30
    t.string 'type', limit: 30
    t.integer 'width'
    t.integer 'height'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[assetable_type assetable_id], name: 'idx_ckeditor_assetable'
    t.index %w[assetable_type type assetable_id], name: 'idx_ckeditor_assetable_type'
  end

  create_table 'comments', id: :integer, force: :cascade do |t|
    t.integer 'author'
    t.text 'page'
    t.text 'content'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'image_file_name'
    t.string 'image_content_type'
    t.integer 'image_file_size'
    t.datetime 'image_updated_at'
    t.string 'accepted', limit: 45
  end

  create_table 'hot_products', id: :integer, force: :cascade do |t|
    t.string 'productId', limit: 45
    t.text 'productTitle'
    t.text 'productUrl'
    t.text 'promotionUrl'
    t.text 'imageUrl'
    t.string 'originalPrice', limit: 45
    t.string 'salePrice', limit: 45
    t.float 'discount'
    t.integer 'lotNum'
    t.string 'thirtydaysCommission', limit: 45
    t.string 'packageType', limit: 45
    t.float 'evaluateScore'
    t.date 'validTime'
    t.integer 'quanity_sold'
    t.float 'commision'
    t.integer 'volume'
    t.text 'aff_url'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'category', default: 50, null: false
    t.integer 'subcategory'
    t.integer 'sub_subcategory'
    t.text 'storeName'
    t.text 'storeUrl'
  end

  create_table 'product_likes', id: :integer, force: :cascade do |t|
    t.integer 'user_id'
    t.string 'user_cookie_id', limit: 45
    t.integer 'product_id'
    t.date 'created_at', null: false
    t.date 'updated_at', null: false
    t.index ['product_id'], name: 'fk_rails_9fdc191f6f'
  end

  create_table 'products', id: :integer, force: :cascade do |t|
    t.string 'productId', limit: 45
    t.text 'productTitle'
    t.text 'productDescription'
    t.text 'productUrl'
    t.text 'promotionUrl'
    t.text 'imageUrl'
    t.float 'originalPrice'
    t.float 'salePrice'
    t.text 'storeName'
    t.text 'storeUrl'
    t.float 'discount'
    t.integer 'lotNum'
    t.string 'thirtydaysCommission', limit: 45
    t.string 'packageType', limit: 45
    t.float 'evaluateScore'
    t.date 'validTime'
    t.integer 'volume'
    t.text 'aff_url'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'category_id', default: 50
    t.integer 'subcategory_id'
    t.string 'is_hot', limit: 3
    t.string 'is_approved', limit: 3
    t.string 'with_reviews', limit: 1
    t.string 'archived', limit: 1
    t.integer 'like_count'
    t.index ['category_id'], name: 'fk_rails_fb915499a4'
    t.index ['productId'], name: 'productId', unique: true
    t.index ['subcategory_id'], name: 'fk_rails_150008c07d'
  end

  create_table 'reviews', id: :integer, force: :cascade do |t|
    t.text 'title'
    t.text 'short_description'
    t.text 'long_description'
    t.text 'keywords'
    t.float 'price', null: false
    t.float 'rating', null: false
    t.text 'promoted'
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.string 'cover_file_name'
    t.string 'cover_content_type'
    t.integer 'cover_file_size'
    t.datetime 'cover_updated_at'
    t.integer 'user_id'
    t.string 'product_id', limit: 45, null: false
    t.index ['user_id'], name: 'fk_rails_74a66bd6c5'
  end

  create_table 'subcategories', id: :integer, force: :cascade do |t|
    t.integer 'category_id'
    t.text 'name'
  end

  create_table 'users', id: :integer, force: :cascade do |t|
    t.text 'nickname'
    t.text 'password'
    t.text 'encrypted_password'
    t.text 'name'
    t.text 'surname'
    t.text 'description'
    t.text 'email'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'avatar_file_name'
    t.string 'avatar_content_type'
    t.integer 'avatar_file_size'
    t.datetime 'avatar_updated_at'
    t.string 'is_admin', limit: 3
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.integer 'sign_in_count', default: 0, null: false
    t.datetime 'current_sign_in_at'
    t.datetime 'last_sign_in_at'
    t.string 'current_sign_in_ip'
    t.string 'last_sign_in_ip'
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
  end

  add_foreign_key 'product_likes', 'products'
  add_foreign_key 'products', 'categories'
  add_foreign_key 'products', 'subcategories'
  add_foreign_key 'reviews', 'users'
end
