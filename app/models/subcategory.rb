class Subcategory < ApplicationRecord
  has_many :products
  scope :find_all_products_of_parent, -> { where(parent: params[:category_id]).all }
  scope :find_all_of_parent, ->(parent) { select(:id).where(parent: parent) }
  scope :fast_product, -> { joins(:products) }

  def self.fill_all_subcategories_of_category(category)
    @subcategories = Subcategory.find_all_of_parent(category)
    @subcategories.each do |subcategory|
      @products = AliexpressScraper.search_for_category_products('', subcategory.id)
      Product.save_hot_products(@products['result']['products'], params[:category][:fields][1], subcategory.id)
    end
  end

  def with_products?
    !products.empty?
  end
end
