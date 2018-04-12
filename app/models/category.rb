class Category < ApplicationRecord
  has_many :subcategories
  has_many :products

  def save_fetched_categories_and_subcategories
  	page.css(".item.util-clearfix").each do |category|
      category_name = category.css(".big-title").css('a').text
      category_id = category.css('a').to_s.split("/")[4]
      category.css(".sub-item-cont").css('a').each do |subcategory|
        subcategory_name = subcategory.text
        subcategory_id = subcategory.to_s.split("/")[4]
        Subcategory.create(category_id: @category_id, name: subcategory_name, id: subcategory_id) if Subcategory.find(subcategory_id).nil?
      end
      Category.create(id: category_id, name: category_name) if Category.find(category_id).nil?
    end
  end
end
