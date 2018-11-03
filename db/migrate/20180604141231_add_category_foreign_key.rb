# frozen_string_literal: true

class AddCategoryForeignKey < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :products, :categories
  end
end
