class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :author
      t.text :page
      t.text :content

      t.timestamps null: false
    end
  end
end
