class VisitorsController < ApplicationController
  
	def index
		@items = Item.all.order("id desc")
		@best_items = Item.where(:is_hot => "y").limit(8) #limit%4=0!!
		@categories = Category.all.limit(3)
		@recent_reviews = Review.all.limit(3)

		#META
    	set_meta_tags title: "Home"
   	 	set_meta_tags description: "Here you can find new hot products from AliExpress with reviews and user feedback! Buy smarter with us!"
    	set_meta_tags keywords: "aliexpress,deal,review,shipping,how to buy,faq,prices,products,deals,find,review,test"
	end
	
	def search_items
		@alicrawler_params = AliCrawler.new
	end
	
	def list_items
		@items = AliCrawler.new.search_url_generator(params)
		categoryId = params[:category][:fields][1]
		save_items = Item.ali_new(@items["result"]["products"], categoryId)
	end

	def save_items
		save_items = Item.clear_unwanted_items(params[:productId])
		product_urls = Item.where(:promotionUrl => nil).select(:productUrl, :id).limit(40).order("id desc")
		puts product_urls.class
		promotion_urls = AliCrawler.new.get_promotion_links(product_urls)
		Item.add_promotion_links(promotion_urls["result"]["promotionUrls"],product_urls)
	end

	def hot_products

	end
		
end