=begin
  ------------------------------ NAVIGATION ----------------------
    1 - Search in Aliexpress Api methods/helper
      1.1 - Generate url to search by params from /admin/form
      1.2 - Generate url to search by kewrods inputed in file

    2 - Search for hot/similar products
      2.1 - Find hot products
      2.2 - Find similar products

    3 - Get product details from Aliexpress Api
      3.1 - Find product details using Api
      3.2 - Get affilate links for product

    4 - Fetch product details

    5 - Calling function

=end

require "net/http"
require "json"
require "open-uri"
require "rest-client"

class AliexpressScraper
  #--------------------------------------------------------------------------
  # 1 - Search in Aliexpress Api methods/helper
  # 1.1 - Generate url to search by params from /admin/form
  def self.search_url_generator(params)
    fields = AliConfig.new.alibaba_api_fields["list"].join(",")
    sort = ""
    hot_products = "false"
    sort = "commissionRateUp" if params[:sort][:commissionRateUp].to_s == "1"
    hot_products = "true" if params[:hot_products][:yesno].to_s == "1"
    url = "https://gw.api.alibaba.com/openapi/param2/2/portals.open/api.listPromotionProduct/#{AliConfig.new.api_key}?fields=#{fields}&keywords=#{params[:keyword]}&categoryId=#{params[:category][:fields][1]}&pageSize=40&sort=#{sort}&startCreditScore=#{params[:min_seller_rating]}&endCreditScore=#{params[:max_seller_rating]}"
    make_call(url)
  end

  # 1.2 - Generate url to search by keywords and category
  def self.search_for_category_products(keyword, category)
    fields = AliConfig.new.alibaba_api_fields["list"].join(",")
    url = "https://gw.api.alibaba.com/openapi/param2/2/portals.open/api.listPromotionProduct/#{AliConfig.new.api_key}?fields=#{fields}&keywords=#{keyword}&categoryId=#{category}&pageSize=40&highQualityItems=true&sort=commissionRateUp"
    make_call(url)
  end

  #--------------------------------- 1 - END ---------------------------------
  # 2 -  Find hot/similar products
  # 2.1 - Find hot products
  def self.get_hot_products(currency, category, language)
    url = "http://gw.api.alibaba.com/openapi/param2/2/portals.open/api.listHotProducts/#{AliConfig.new.api_key}?localCurrency=#{currency}&categoryId=#{category}&language=#{language}"
    make_call(url)
  end

  # 2.2 - Find similar products
  def self.get_similar_products(product_id)
    url = "http://gw.api.alibaba.com/openapi/param2/2/portals.open/api.listSimilarProducts/#{AliConfig.new.api_key}?productId=#{product_id}"
    logger.info(url)
    make_call(url)
  end

  #--------------------------- 2 - END --------------------------------------
  # 3 - Get product details from aliexpress api
  # 3.1 - Find product details
  def self.get_product_details(fields, product_id)
    fields = fields.join(",")
    url = "http://gw.api.alibaba.com/openapi/param2/2/portals.open/api.getPromotionProductDetail/#{AliConfig.new.api_key}?fields=#{fields}&productId=#{product_id}"
    make_call(url)
  end

  # 3.2 - Get affilate links for product
  def self.get_promotion_links(product_urls)
    if product_urls.class == String # checking that we sent to method many urls or just one
      urls = product_urls
    else
      urls = []
      product_urls.each do |product|
        urls << product.productUrl
      end
      urls = urls.join(",")
    end

    url = "http://gw.api.alibaba.com/openapi/param2/2/portals.open/api.getPromotionLinks/#{AliConfig.new.api_key}?fields=totalResults,trackingId,publisherId,url,promotionUrl&trackingId=Luirun&urls=#{urls}"
    make_call(url)
  end

  #-------------------------------- 3 - END -------------------------------
  # 4 - Fetch product details
  def self.fetch_product_details(browser)
    doc = Nokogiri::HTML.parse(browser.html)
    if browser.element(class: "info-404").exists?
      return "end"
    else
      description = doc.css(".ui-box.product-property-main")
      browser.send_keys :space
      browser.element(class: "ui-switchable-trigger", index: 1).link.click # load feedback tab
      sleep(1)
      # if doc.css(".no-feedback.wholesale-product-feedback") != nil  OLD NOT WORKING IF
      if !browser.element(id: "feedback").iframe(index: 0).element(id: "transction-feedback").exists?
        feedback = {"feedback" => [], "user_info" => []}
        feedback[:feedback][0] = nil # empty feedback to push script to work when we have nothing
        product_details = [description, feedback]
      else
        feedback_doc = browser.element(id: "feedback").iframe(index: 0).element(id: "transction-feedback") # inspect iframe with feedbacks
        feedback_doc = Nokogiri::HTML.parse(feedback_doc.html)
        feedback = {"feedback" => [], "user_info" => []} # hash for feedback details and feedback user
        feedback_doc.css(".fb-main").each do |feed| # looping every review of product
          user_order_rate = feed.css(".star-view").children.at("span")["style"].to_s
          user_order_rate = user_order_rate.slice(6..8).to_i # creating % rate from style of span
          user_order_info = feed.css(".user-order-info").text # color, delivery type etc text
          user_review = feed.css(".buyer-feedback").css("span").text # user reviews
          username = feed.css(".fb-user-info").text
          review_photos = []
          feed.css(".pic-view-item").each do |photo|
            review_photos << photo.css("img").at("img")["src"] # saving all photos to photo url
          end
          review_date = feed.css(".r-time").text
          result = {"user_order_rate" => user_order_rate, "user_order_info" => user_order_info,
                    "user_review" => user_review, "review_photos" => review_photos, "review_date" => review_date}
          # saving every detail of review into new element of feedback hash
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
    # puts feedback
    product_details = [description, feedback]
    return product_details
  end

  #------------------------------------------------ 4 - END -------------------------------------------------
  # 5 - Calling method
  def self.make_call(url)
    response = RestClient.get(url)
    if response.code != 200
      logger.fatal "Error, response code: #{response.code} for url: #{url}"
    else
      result = JSON.parse(response)
      logger.fatal "error!" if result["errorCode"] != 200_100_00
      puts result["result"]["products"]
      return result
    end
  end

  #-------------------------------------------------- 5 - END ------------------------------------------------
end