class AliReview < ActiveRecord::Base

	def save_product_reviews(reviews, productId)
		i = 0
		if reviews[:feedback][0] == nil #if there is no reviews on aliexpress we are creating an empty one with is_empty = "y"
			review = AliReview.new
			review.is_empty = "y"
			review.productId = productId
			review.save
			item = Item.where(:productId => productId).first
			item.with_reviews = "y"
			item.save
		else
			reviews[:feedback].each do |feedback| #saving every not empty review with user details
				review = AliReview.new
				review.productId = productId	
				review.username = reviews[:user_info][i]["username"]
				review.user_country = reviews[:user_info][i]["user_country"]
				review.user_order_rate = feedback["user_order_rate"]
				review.user_order_info = feedback["user_order_info"]
				review.review_content = feedback["user_review"]
				review.review_date = feedback["review_date"]
				review.review_photos = feedback["review_photos"].join(",")
				review.is_empty = "n"
				review.save
				i = i + 1
			end
			item = Item.where(:productId => productId).first
			item.with_reviews = "y"
			item.save
		end
		
	end

	def delete_empty_reviews(reviews)
		reviews.delete_all
	end

end
