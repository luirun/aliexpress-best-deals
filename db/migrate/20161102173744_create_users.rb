# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text :nickname
      t.text :password
      t.text :password_digest
      t.text :name
      t.text :surname
      t.text :description
      t.text :email

      t.timestamps null: false
    end
  end
end
