class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.text :name
      t.text :image
      t.text :url
      t.float :price
      t.integer :quanity_sold
      t.float :commision
      t.date :out_of_stock
      t.float :discount
      t.text :aff_url

      t.timestamps null: false
    end
  end
end
