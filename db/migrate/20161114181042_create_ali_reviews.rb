# frozen_string_literal: true

class CreateAliReviews < ActiveRecord::Migration
  def change
    create_table :ali_reviews do |t|
      t.text :productId
      t.text :username
      t.text :user_country
      t.integer :user_order_rate
      t.text :user_order_info
      t.text :review_date
      t.text :review_content
      t.text :review_photos

      t.timestamps null: false
    end
  end
end
