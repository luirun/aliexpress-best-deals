class AdminsController < ApplicationController

	before_action :is_admin


	def index

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


	#this action will take 15-20min to be done, be sure you are able to start it now!
	def auto_hot_products
		if request.post?
		    @categories = Category.all
		    @categories.each do |category|
			    @items = AliCrawler.new.get_hot_products("USD", category.id, "EN")
			    save_items = Item.save_hot_products(@items["result"]["products"], category.id)
		    end
		end
	end

	def article_manager
		@articles = Review.all
	end

	def comments_manager
		@unapproved_comments = Comment.all.where(:accepted => "n").order("id desc")
	end

	def comments_manager_update
		params[:commentId].each do |comment|
			#approve procedure
			if comment[1][(comment[1].length) - 1]  == 'a'
				comment[1][(comment[1].length) - 1] = ''
				accept = Comment.find(comment[1])
				accept.accepted = "y"
				accept.save
			end
			#delete procedure
			if comment[1][(comment[1].length) - 1]  == 'd'
				comment[1][(comment[1].length) - 1] = ''
				deleted = Comment.find(comment[1])
				deleted.delete
			end
		end
		redirect_to admins_path
	end

	def clear_expired_items
    	items = Item.clear_expired_items()
  	end

  	def save_from_file
  		keywords = params[:keywords]["fields"].read
  		category = params[:category][:fields][1]
  		keywords = keywords.split(",")
  		keywords.each do |keyword|
  			@items = AliCrawler.new.search_for_items(keyword,category)
  			save_items = Item.save_hot_products(@items["result"]["products"], category)
  		end
  		redirect_to admins_path
  	end

end