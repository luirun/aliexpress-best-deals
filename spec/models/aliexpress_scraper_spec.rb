require 'rails_helper'

describe AliexpressScraper do

  let!(:params) { { keyword: "xiaomi", :category => {fields: ['',44]}, :sort => {commissionRateUp: 1}, :hot_products => {yesno: 1},
                min_seller_rating: 0, max_seller_rating: 99999 } }
  let!(:url) { "https://gw.api.alibaba.com/openapi/param2/2/portals.open" }

  describe "check params hash" do
    it "is valid when" do
      expect(params[:keyword]).to be_a(String)
      expect(params[:sort][:commissionRateUp]).to be_between(0,1)
      expect(params[:category][:fields][1]).to be_a(Numeric)
      expect(params[:min_seller_rating]).to be < params[:max_seller_rating]
      expect(url).to include("https://gw.api.alibaba.com/openapi/param2/2/portals.open")
    end
  end

  # REVIEW: Can't you just delete it?
  describe '#search_url_generator' do
    it 'receives valid parameters and return 2001000 error code from make_call method' do
      expect(described_class.search_for_category_products(params[:keyword], params[:category][:fields][1], params)["errorCode"])
        .to be == 20010000
    end
  end

  describe '#search_for_category_products' do
    it 'got valid parameters and return 2001000 error code from make_call method' do
      expect(described_class.search_for_category_products(params[:keyword], params[:category][:fields][1])["errorCode"])
        .to be == 20010000
    end
  end

  describe '#get_hot_products' do
    it "got passed valid arguments and return 2001000 error code from make_call method" do
      currency = "usd"
      category =  5090301
      language = "en"

      expect(described_class.get_hot_products(currency, category, language)["errorCode"]).to be == 20010000
    end
  end

  # actually disabled by Aliexpress
  # describe '.get_similar_products' do
    # productId = 32798037929

    # it "got valid product Id" do
    # expect(productId).to be_a(Numeric)
    # end

    # it 'create url to find similar products' do
    # expect(url).to include("https://gw.api.alibaba.com/openapi/param2/2/portals.open")
    # end

    # it 'return 2001000 error code from make_call method' do
    # expect(described_class.get_similar_products(productId)["errorCode"]).to be == 20010000
    # end
  # end

  describe '#get_product_details' do
    let(:productId) { 32798037929 }
    let(:fields) { ['productId','productTitle'] }

    it 'returned 2001000 code after connecting to Aliexpress API using make_call method' do
      expect(described_class.get_product_details(fields, productId)["errorCode"]).to be == 20010000
    end

    it 'got fields argument not as array' do
      expect { described_class.get_product_details("fields", productId)["errorCode"] }.to raise_error(NoMethodError)
    end
  end

  describe '#get_promotion_links' do

    context 'when only one product passed' do
      it 'has set urls to equal method arguments' do
        urls = "product_url"
        expect(urls).to_not include(",")
      end
    end

    context 'when many products passed' do
      it 'has created string with all product urls joined by comma' do
        urls = 'product_url1,product_url2,product_url3'
        expect(urls).to include(",")
      end
    end

    it 'return 2001000 error code from make_call method' do
      product_url = "https://www.aliexpress.com/item/Girls-Dress-2016-Summer-Chiffon-Party-Dress-Infant-1-Year-Birthday-Dress-Baby-Girl-Clothing-Dresses/32691146516.html"
      expect(described_class.get_promotion_links(product_url)["errorCode"]).to be == 20010000
    end
  end

  describe '#fetch_product_details' do
    # TODO:
    #this method uses watir to browse aliexpress, came back here later when you will be better with testing
  end

  describe "#call_API" do
    let(:valid_url) { "https://gw.api.alibaba.com/openapi/param2/2/portals.open/api.listPromotionProduct/52761?fields=totalResults,productId,productTitle,productUrl,imageUrl,originalPrice,salePrice,discount,evaluateScore,commission,commissionRate,30daysCommission,volume,packageType,lotNum,validTime,commissionRate&keywords=xiaomi&categoryId=44&pageSize=40&sort=&startCreditScore=&endCreditScore=" }
    let(:unvalid_url) { "https://gw.api.alibaba.com/openapi/param2/2/portals.open/api.listPromotionProduct/52761?fields=totalResults,productId,productTitle,productUrl,imageUrl,originalPrice,salePrice,discount,evaluateScore,commission,commissionRate,30daysCommission,volume,packageType,lotNum,validTime,commissionRate&keywords=xiaomi&categoryId=4234&pageSize=40&sort=aa&startCreditScore=&endCreditScore=" }
    context "server unavailabe" do
      it "return error with response code to logger" do
        expect { described_class.call_API("https://httpstat.us/400") }.to raise_error(RestClient::BadRequest)
      end
    end

    context "call made with not valid API link" do
      it "return 200 100 00 code" do
        expect(described_class.call_API(valid_url)["errorCode"]).to eq 20010000
      end
    end

    context "call made with unvalid API link" do
      it "return other code" do
        expect(described_class.call_API(unvalid_url)["errorCode"]).not_to eq 20010000
      end
    end
  end

end