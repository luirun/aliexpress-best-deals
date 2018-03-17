require 'net/http'
require 'json'
require 'open-uri'
require 'rest-client'

class AliCrawler

			#used to search items by keywords with on page form
			def search_url_generator(params)
				fields = AliConfig.new.alibaba_api_fields[:list].join(",")
				sort = ""
				hot_products= "false"
				keywords = params[:keywords]
				
				if params[:sort][:commissionRateUp].to_s == "1"
					sort = "commissionRateUp"
				end
				
				if params[:hot_products][:yesno].to_s == "1"
					hot_products = "true"
				end
				
				url = "https://gw.api.alibaba.com/openapi/param2/2/portals.open/api.listPromotionProduct/#{AliConfig.new.api_key}?fields=#{fields}&keywords=#{params[:keywords]}&categoryId=#{params[:category][:fields][1]}&pageSize=40&sort=#{sort}&startCreditScore=#{params[:min_seller_rating]}&endCreditScore=#{params[:max_seller_rating]}"
				puts url
				
				make_call(url)
				
			end

			#used to search items without on page form - from keywords inputted in file
			def search_for_items(keyword,category)
				fields = AliConfig.new.alibaba_api_fields[:list].join(",")
				hot_products= "false"
				
				url = "https://gw.api.alibaba.com/openapi/param2/2/portals.open/api.listPromotionProduct/#{AliConfig.new.api_key}?fields=#{fields}&keywords=#{keyword}&categoryId=#{category}&pageSize=40&highQualityItems=true&sort=commissionRateUp"
				puts url
				
				make_call(url)
				
			end

			def get_product_description(productUrl)
				browser = Watir::Browser.new
				browser.window.resize_to(1280,920)
				browser.goto productUrl

				sleep(rand(3..7))

				doc = Nokogiri::HTML.parse(browser.html)
				description = doc.css(".ui-box.product-property-main")
				browser.element(:class => "ui-switchable-trigger", :index => 1).link.click #load feedback tab
				sleep(1)
				feedback_doc = browser.element(:id => "feedback").iframe(:index => 0).element(:id => "transction-feedback") #inspect iframe with feedbacks
				feedback_doc = Nokogiri::HTML.parse(feedback_doc.html)

				if doc.css("#feedback.ui-tab-pane.ui-switchable-panel").css("iframe").at("iframe").nil?
					feedback = {'feedback': [], 'user_info': []} 
					feedback[:feedback][0] = nil #empty feedback to push script to work when we have nothing
					product_details = [description,feedback]
				else
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

					puts feedback
					product_details = [description,feedback]
				end

				return product_details
			end
			
			def get_product_details(fields, product_id)

				fields = fields.join(",")
				url = "http://gw.api.alibaba.com/openapi/param2/2/portals.open/api.getPromotionProductDetail/#{AliConfig.new.api_key}?fields=#{fields}&productId=#{product_id}"
				puts url

				make_call(url)

			end
			
			def get_promotion_links(product_urls)
				puts product_urls[0]
				if product_urls.class == String #checking that we sent to method many urls or just one
					urls = product_urls
				else
					urls = []
					product_urls.each do |product|
						urls << product.productUrl
					end
					urls = urls.join(",")
				end

				url = "http://gw.api.alibaba.com/openapi/param2/2/portals.open/api.getPromotionLinks/#{AliConfig.new.api_key}?fields=totalResults,trackingId,publisherId,url,promotionUrl&trackingId=Luirun&urls=#{urls}"
				puts url
				
				make_call(url)
			end

			def get_hot_products(currency, categories, language)

				url = "http://gw.api.alibaba.com/openapi/param2/2/portals.open/api.listHotProducts/#{AliConfig.new.api_key}?localCurrency=#{currency}&categoryId=#{categories}&language=#{language}"
				puts url
				make_call(url)
				
			end


			def get_similar_products(productId)

				url = "http://gw.api.alibaba.com/openapi/param2/2/portals.open/api.listSimilarProducts/#{AliConfig.new.api_key}?productId=#{productId}"
				puts url
				make_call(url)

			end
			
			def make_call(url)
				response = RestClient.get(url)
				if response.code != 200
					puts url
					puts response.code
					puts "Error!"
				else
					result = JSON.parse(response)
					
					if result['errorCode'] != 20010000
						puts "error!"
					else
						return result
					end
				end
			end
		
		
end