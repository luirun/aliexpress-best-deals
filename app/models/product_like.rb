class ProductLike < ApplicationRecord
  belongs_to :product
  belongs_to :user

  validates :user_id, presence: true
  validates :product_id, presence: true

  def self.create_like(product_id, current_user_id, cookie_id)
    if ProductLike.find_by(product_id: product_id, user_id: current_user_id).nil?
      ProductLike.create(product_id: product_id, user_id: current_user_id, user_cookie_id: cookie_id)
    else
      logger.fatal('This action shouldn\'t be allowed from UI!')
    end
  end

  def self.destroy_like(product_id, cookie_id)
    ProductLike.find_by(product_id: product_id, user_cookie_id: cookie_id).destroy
  end
end
