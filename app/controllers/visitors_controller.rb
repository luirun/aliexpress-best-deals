class VisitorsController < ApplicationController
	before_action :is_admin, only: [:search_items]
  
	def index
		@recent_reviews = Review.all.limit(3)
		session[:excluded_categories] = []

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
		if product_urls[0] != nil
			promotion_urls = AliCrawler.new.get_promotion_links(product_urls)
			Item.add_promotion_links(promotion_urls["result"]["promotionUrls"],product_urls)
		end
	end

	def hot_products

	end

	def new_items_append
		respond_to do |format|               
			format.js
		end    
	end

	def error404
		#META
    	set_meta_tags title: "404 Page not found!"
   	 	set_meta_tags description: "This page doesnt exist! But you may back to our home page and discover our website!"
    	set_meta_tags keywords: "aliexpress,deal,review,error,page,404"
	end
		
end