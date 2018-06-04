class AddProductsForeignKeys < ActiveRecord::Migration[5.2]
  def change
  	add_foreign_key :products, :subcategories
  	add_foreign_key :product_likes, :products
  end
end
