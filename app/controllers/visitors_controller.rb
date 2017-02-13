class VisitorsController < ApplicationController
	before_action :is_admin, only: [:search_items]
  
	def index
		@recent_reviews = Review.all.limit(3).order("id desc")
		session[:excluded_categories] = []

		#META
    	set_meta_tags title: "Home"
   	 	set_meta_tags description: "Here you can find new hot products from AliExpress with reviews and user feedback! Buy smarter with us!"
    	set_meta_tags keywords: "aliexpress,deal,review,shipping,how to buy,faq,prices,products,deals,find,review,test"
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