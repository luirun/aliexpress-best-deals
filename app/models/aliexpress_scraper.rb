require "net/http"
require "json"
require "open-uri"
require "rest-client"

class AliexpressScraper
  # Generate url to search for products by keywords and category
  def self.search_for_category_products(keyword, category, filters = nil)
    if filters.nil?
      sort = ""
      hot_products = ""
      min_seller_rating = ""
      max_seller_rating = ""
    else
      filters[:sort][:commissionRateUp].to_s == "1" ? sort = "commissionRateUp" : sort = ""
      filters[:hot_products][:yesno].to_s == "1" ? hot_products = "true" : hot_products = ""
      min_seller_rating = filters[:min_seller_rating]
      max_seller_rating = filters[:max_seller_rating]
    end
    fields = AliConfig.new.alibaba_api_fields["list"].join(",")
    url = "https://gw.api.alibaba.com/openapi/param2/2/portals.open/api.listPromotionProduct/#{AliConfig.new.api_key}" \
          "?fields=#{fields}&keywords=#{keyword}&categoryId=#{category}&pageSize=40&sort=#{sort}"                      \
          "&startCreditScore=#{min_seller_rating}&endCreditScore=#{max_seller_rating}"
    call_API(url)
  end

  def self.get_hot_products(currency, category, language)
    url = "http://gw.api.alibaba.com/openapi/param2/2/portals.open/api.listHotProducts/#{AliConfig.new.api_key}?localCurrency=#{currency}"  \
    "&categoryId=#{category}&language=#{language}"
    call_API(url)
  end

  def self.get_similar_products(product_id)
    url = "http://gw.api.alibaba.com/openapi/param2/2/portals.open/api.listSimilarProducts/#{AliConfig.new.api_key}?productId=#{product_id}"
    logger.info(url)
    call_API(url)
  end

  def self.get_product_details(fields, product_id)
    fields = fields.join(",")
    url = "http://gw.api.alibaba.com/openapi/param2/2/portals.open/api.getPromotionProductDetail/#{AliConfig.new.api_key}?fields=#{fields}&productId=#{product_id}"
    call_API(url)
  end

  # Get affilate links for products
  def self.get_promotion_links(product_urls)
    urls = !product_urls.kind_of?(String) ? product_urls.join(",") : product_urls
    url = "http://gw.api.alibaba.com/openapi/param2/2/portals.open/api.getPromotionLinks/#{AliConfig.new.api_key}?" \
          "fields=totalResults,trackingId,publisherId,url,promotionUrl&trackingId=Luirun&urls=#{urls}"
    call_API(url)
  end

  def self.fetch_product_details(browser)
    doc = Nokogiri::HTML.parse(browser.html)
    return if browser.element(class: "info-404").exists?
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
        user_order_info = feed.css(".user-order-info").text # color, delivery type etc. text
        user_review = feed.css(".buyer-feedback").css("span").text # user reviews
        username = feed.css(".fb-user-info").text
        review_photos = []
        feed.css(".pic-view-item").each do |photo|
          review_photos << photo.css("img").at("img")["src"] # saving all photos to photo url
        end
        review_date = feed.css(".r-time").text
        result = {"user_order_rate" => user_order_rate, "user_order_info" => user_order_info,
          "user_review" => user_review, "review_photos" => review_photos, "review_date" => review_date,
          "user_name" => username}
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
    # puts feedback
    return [description, feedback]
  end

  def self.call_API(url)
    response = RestClient.get(url)
    if response.code != 200
      Rails.logger.fatal("Error, response code: #{response.code} for url: #{url}")
    else
      result = JSON.parse(response)
      Rails.logger.fatal("Error: #{result["errorCode"]}") if result["errorCode"] != 200_100_00
      return result
    end
  end
end
