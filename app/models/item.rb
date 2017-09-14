class Item < ActiveRecord::Base

	def self.ali_new(items, categoryId)
		if items.length > 1 #checking that there is one or more products
			items.each do |i|
				id_exist = Item.where(:productId => i["productId"].to_s).first
				if id_exist != nil
					puts "Product Already Exists"
				else
					a = i['30daysCommission']
					i = i.except('30daysCommission')
					item = Item.new(i)
					item.salePrice = i["salePrice"].slice(4..12)
					item.productTitle = ActionView::Base.full_sanitizer.sanitize(i["productTitle"])
					item.originalPrice = i["originalPrice"].slice(4..12)
					item.thirtydaysCommission = a
					item.is_approved = "n"
					item.category = categoryId
					item.save
				end
			end
		else
			i = items
			#puts i
			a = i['30daysCommission']
			i = i.except('30daysCommission')
			item = Item.new(i)
			item.salePrice = i["salePrice"].slice(4..12)
			item.productTitle = ActionView::Base.full_sanitizer.sanitize(i["productTitle"])
			item.originalPrice = i["originalPrice"].slice(4..12)
			item.thirtydaysCommission = a
			item.is_approved = "n"
			item.category = categoryId
			item.save
		end
	end

	def self.clear_unwanted_items(products)

		#approving all checked items
		if products == nil
			puts "there is no products to approve"
		else
			products.each do |p|
				item = Item.where(:productId => p).first
				item.is_approved = "y"
				item.save
			end
		end

		#deleting unselected items
		a = Item.all.limit(40).order("id desc")
		a.each do |item|
			if item.is_approved != "y"
				item.delete
			end
		end

	end

	def self.add_promotion_links(promotion_urls, products)
		
		i = 0
		products.each do |product|
			product = Item.find(product.id)
			product.promotionUrl = promotion_urls[i]["promotionUrl"]
			puts promotion_urls[i]["promotionUrl"]
			product.save
			i += 1
		end

	end

	def self.save_product_description(productDescription, itemId)
		item = Item.find(itemId)
		item.productDescription = productDescription
		item.save
	end

	#method for mass saving items founded by crawler - works well for saving from file and iterating through the categories
	def self.save_hot_products(items, categoryId)
		items.each do |i|
			fields = ['productId','productTitle','productUrl','imageUrl','originalPrice','salePrice','discount','evaluateScore','commission','commissionRate','30daysCommission','volume','packageType','lotNum','validTime','storeName','storeUrl']
			details = AliCrawler.new.get_product_details(fields,i["productId"]) #gettig all details about product from hot product list
			if details["result"] == nil
				puts "cisza nocna"
			else
				id_exist = Item.where(:productId => i["productId"]).first
				if id_exist != nil
					puts "Product Already Exists"
				else
					details = details["result"]
					a = details["30daysCommission"]
					i = details.except('30daysCommission')
					promotion_link = AliCrawler.new.get_promotion_links(i["productUrl"]) #getting promotion url from aliexpress
					promotion_link = promotion_link["result"]["promotionUrls"] #shortening our hash a little
					item = Item.new(i)  #making new instance in Hot Products table
					item.salePrice = i["salePrice"].slice(4..12)
					item.originalPrice = i["originalPrice"].slice(4..12)
					item.promotionUrl = promotion_link[0]["promotionUrl"] #saving promotion url to record
					item.thirtydaysCommission = a #adding 30 days commission to record
					item.category = categoryId
					item.is_hot = "y"
					item.is_approved = "y"
					item.save
				end
			end
		end
	end

	def self.add_promotion_links(promotion_urls, products)
		if promotion_urls[1].nil?  #jezeli dodajemy link do jednego przedmiotu
			products.each do |product|
				product = Item.find(product.id)
				product.promotionUrl = promotion_urls[0]["promotionUrl"]
				product.save
			end
		else #jezeli jest wiele przedmiotow
			i = 0
			products.each do |product|
				product = Item.find(product.id)
				product.promotionUrl = promotion_urls[i]["promotionUrl"]
				puts promotion_urls[i]["promotionUrl"]
				product.save
				i += 1
			end
		end

	end

	def self.transform_price
		items = Item.where("salePrice like '%us%'")
		items.each do |item|
			item.salePrice = item.salePrice.slice(4..12)
			item.originalPrice = item.salePrice.slice(4.12)
			item.save
		end

	end
	

	def self.clear_expired_items
		items = Item.where("validTime < '#{Time.now.strftime("%Y-%m-%d").to_s}'")
		items.each do |item|
			item.archived = "y"
			item.save
		end
	end

	def self.fetch_extra_data(browser)
		doc = Nokogiri::HTML.parse(browser.html)
		if browser.element(:class => "info-404").exists?
			return "end"
		else
			description = doc.css(".ui-box.product-property-main")
			browser.element(:class => "ui-switchable-trigger", :index => 1).link.click #load feedback tab
			sleep(1)
			#if doc.css(".no-feedback.wholesale-product-feedback") != nil  OLD NOT WORKING IF
			if !browser.element(:id => "feedback").iframe(:index => 0).element(:id => "transction-feedback").exists?
				feedback = {'feedback': [], 'user_info': []} 
				feedback[:feedback][0] = nil #empty feedback to push script to work when we have nothing
				product_details = [description,feedback]
			else
				feedback_doc = browser.element(:id => "feedback").iframe(:index => 0).element(:id => "transction-feedback") #inspect iframe with feedbacks
				feedback_doc = Nokogiri::HTML.parse(feedback_doc.html)
				feedback = {'feedback': [], 'user_info': []}  #hash for feedback details and feedback user
				feedback_doc.css(".fb-main").each do |feed| #looping every review of product

				user_order_rate = feed.css(".star-view").children.at("span")["style"].to_s
				user_order_rate = user_order_rate.slice(6..8).to_i #creating % rate from style of span

				user_order_info = feed.css(".user-order-info").text #color, delivery type etc text

				user_review = feed.css(".buyer-feedback").css("span").text #user reviews

				username = feed.css(".fb-user-info").text
							
				review_photos = []
				feed.css(".pic-view-item").each do |photo|
					review_photos << photo.css("img").at('img')["src"] #saving all photos to photo url
				end

				review_date = feed.css(".r-time").text

				result = {"user_order_rate" => user_order_rate, "user_order_info" => user_order_info, "user_review" => user_review, "review_photos" => review_photos, "review_date" => review_date}
				#saving every detail of review into new element of feedback hash
				feedback[:feedback] << result
			end

			feedback_doc.css(".fb-user-info").each do |user|

				username = user.css(".user-name").text
				user_country = user.css(".user-country").text

				result = {"username" => username, "user_country" => user_country}
				feedback[:user_info] << result
			
			end
		end
	end
		#puts feedback
		product_details = [description,feedback]
		return product_details

	end

end
