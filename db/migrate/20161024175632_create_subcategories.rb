class CreateSubcategories < ActiveRecord::Migration
  def change
    create_table :subcategories do |t|
      t.integer :parent
      t.text :name

      t.timestamps null: false
    end
  end
end
