class CreateSubsubcategories < ActiveRecord::Migration
  def change
    create_table :subsubcategories do |t|
      t.integer :parent
      t.text :name

      t.timestamps null: false
    end
  end
end
