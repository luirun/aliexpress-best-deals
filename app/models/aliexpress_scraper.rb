require 'net/http'
require 'json'
require 'open-uri'
require 'rest-client'

class AliexpressScraper
  # Generate url to search for products by keywords and category
  def self.products_in_category(keyword, category, params=nil)
    params = {
      fields:            AliConfig.new.alibaba_api_fields['list'].join(','),
      sort:              params[:sort][:commissionRateUp].to_s == '1' ? 'commissionRateUp' : '',
      hot_products:      params[:hot_products][:yesno].to_s == '1' ? 'true' : '',
      min_seller_rating: params[:min_seller_rating],
      endCreditScore:    params[:max_seller_rating],
      categoryId:        category,
      keywords:          keyword,
      pageSize:          40
    }

    Transport.get(path: '/api.listPromotionProduct', params: params).fetch(:products)
  end

  def self.get_hot_products(currency, category, language)
    url = "http://gw.api.alibaba.com/openapi/param2/2/portals.open/api.listHotProducts/#{AliConfig.new.api_key}" \
          "?localCurrency=#{currency}&categoryId=#{category}&language=#{language}"
    call_API(url)
  end

  def self.get_similar_products(product_id)
    url = "http://gw.api.alibaba.com/openapi/param2/2/portals.open/api.listSimilarProducts/#{AliConfig.new.api_key}?productId=#{product_id}"
    logger.info(url)
    call_API(url)
  end

  def self.get_product_details(fields, product_id)
    fields = fields.join(',')
    url = "http://gw.api.alibaba.com/openapi/param2/2/portals.open/api.getPromotionProductDetail/#{AliConfig.new.api_key}?fields=#{fields}&productId=#{product_id}"
    call_API(url)
  end

  # Get affilate links for products
  def self.get_promotion_links(product_urls)
    urls = !product_urls.is_a?(String) ? product_urls.join(',') : product_urls
    url = "http://gw.api.alibaba.com/openapi/param2/2/portals.open/api.getPromotionLinks/#{AliConfig.new.api_key}?" \
          "fields=totalResults,trackingId,publisherId,url,promotionUrl&trackingId=Luirun&urls=#{urls}"
    call_API(url)
  end

  def self.fetch_product_details(browser)
    doc = Nokogiri::HTML.parse(browser.html)
    return if browser.element(class: 'info-404').exists?

    description = doc.css('.ui-box.product-property-main')
    browser.send_keys :space
    browser.element(class: 'ui-switchable-trigger', index: 1).link.click # load feedback tab
    sleep(1)
    # if doc.css(".no-feedback.wholesale-product-feedback") != nil  OLD NOT WORKING IF
    if !browser.element(id: 'feedback').iframe(index: 0).element(id: 'transction-feedback').exists?
      feedback = { 'feedback' => [], 'user_info' => [] }
      feedback[:feedback][0] = nil # empty feedback to push script to work when we have nothing
      product_details = [description, feedback]
    else
      feedback_doc = browser.element(id: 'feedback').iframe(index: 0).element(id: 'transction-feedback') # inspect iframe with feedbacks
      feedback_doc = Nokogiri::HTML.parse(feedback_doc.html)
      feedback = { 'feedback' => [], 'user_info' => [] } # hash for feedback details and feedback user
      feedback_doc.css('.fb-main').each do |feed| # looping every review of product
        user_order_rate = feed.css('.star-view').children.at('span')['style'].to_s
        user_order_rate = user_order_rate.slice(6..8).to_i # creating % rate from style of span
        user_order_info = feed.css('.user-order-info').text # color, delivery type etc. text
        user_review = feed.css('.buyer-feedback').css('span').text # user reviews
        username = feed.css('.fb-user-info').text
        review_photos = []
        feed.css('.pic-view-item').each do |photo|
          review_photos << photo.css('img').at('img')['src'] # saving all photos to photo url
        end
        review_date = feed.css('.r-time').text
        result = {
          'user_order_rate' => user_order_rate, 'user_order_info' => user_order_info,
          'user_review' => user_review, 'review_photos' => review_photos, 'review_date' => review_date,
          'user_name' => username
        }
        # saving every detail of review into new element of feedback hash
        feedback[:feedback] << result
      end

      feedback_doc.css('.fb-user-info').each do |user|
        username = user.css('.user-name').text
        user_country = user.css('.user-country').text
        result = { 'username': username, 'user_country': user_country }
        feedback[:user_info] << result
      end
    end
    # puts feedback
    [description, feedback]
  end

  def self.call_API(url)
    response = RestClient.get(url)
    if response.code != 200
      
    else
      result = JSON.parse(response)
      Rails.logger.fatal("Error: #{result['errorCode']}") if result['errorCode'] != 200_100_00
      return result
    end
  end

  module Transport

    def self.generate_params(params)
      params.map { |key, value| "#{key}=#{value}"}.join('&')
    end

    def self.get(path:, params:)
      url = root + path + '/' + AliConfig.new.api_key + '?'
      url += generate_params(params)
      result = RestClient.get(url)
      
      response = { 
        body: JSON.parse(result.body).deep_symbolize_keys,
        headers: result.headers
      }
      request = result.request

      errors(request, response)
    end

    def self.errors(request, response)
      error_code = response[:body][:errorCode]
      if error_code != 200_100_00
        raise "Error #{error_code}: #{error_codes[error_code]}"
      else
        response.fetch(:body).fetch(:result)
      end
    end

    private

    def self.root
      'http://gw.api.alibaba.com/openapi/param2/2/portals.open'
    end

    def self.error_codes
      {
        20010000 => 'Call succeeds',
        20020000 => 'System Error',
        20030000 => 'Unauthorized transfer request',
        20030010 => 'Required parameters',
        20030020 => 'Invalid protocol format',
        20030030 => 'API version input parameter error',
        20030040 => 'API name space input parameter error',
        20030050 => 'API name input parameter error',
        20030060 => 'Fields input parameter error',
        20030070 => 'Keyword input parameter error',
        20030080 => 'Category ID input parameter error',
        20030090 => 'Tracking ID input parameter error',
        20030100 => 'Commission rate input parameter error',
        20030110 => 'Original Price input parameter error',
        20030120 => 'Discount input parameter error',
        20030130 => 'Volume input parameter error',
        20030140 => 'Page number input parameter error',
        20030150 => 'Page size input parameter error',
        20030160 => 'Sort input parameter error',
        20030170 => 'Credit Score input parameter error'
      }
    end

  end
end
