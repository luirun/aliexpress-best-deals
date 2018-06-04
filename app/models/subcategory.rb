class Subcategory < ApplicationRecord
  has_many :products
  scope :find_all_products_of_parent, -> { where(parent: params[:category_id]).all }
  scope :fast_product, -> { joins(:products) }

  def self.fill_all_subcategories_of_category(parent)
    @subcategories = Subcategory.where(parent: parent)
    @subcategories.each do |subcategory|
      @products = AliCrawler.new.search_for_category_products("", subcategory.id)
      Product.save_hot_products(@products["result"]["products"], params[:category][:fields][1], subcategory.id)
    end
  end

  def with_products?
    products.length > 0
  end
end
