class Item < ActiveRecord::Base

	def self.ali_new(items, categoryId)
		puts items

		items.each do |i|
			id_exist = Item.where(:productId => i["productId"]).first
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


	#from old hot_products model

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
		
		i = 0
		products.each do |product|
			product = Item.find(product.id)
			product.promotionUrl = promotion_urls[i]["promotionUrl"]
			puts promotion_urls[i]["promotionUrl"]
			product.save
			i += 1
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
		items = Item.where("validTime < '#{Time.now.strftime("%Y-%d-%m").to_s}'").destroy_all
	end

end
