class Like < ActiveRecord::Base
  def self.new_like(product_id)
    liked = Like.new
    if !current_user.nil?
      liked.userId = current_user.id
    end
    liked.userCookieId = cookies[:user_id]
    liked.productId = product_id
    liked.save
  end
end
