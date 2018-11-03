# frozen_string_literal: true

class AddLikeCountToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :like_count, :integer
  end
end
