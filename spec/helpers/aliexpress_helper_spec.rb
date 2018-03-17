require 'rails_helper'

describe AliexpressHelper do
	#set of variables mostly used in this class
	before(:all) do
		@params = Hash.new
		@params[:category] = Hash.new; @params[:category][:fields] = Hash.new
		@params[:category][:fields][1] = 5090301   #aliexpress category id - mobile phones in this case cause we are looking for xiaomi
		@params[:keyword] = "xiaomi"
		@params[:min_seller_rating] = 0
		@params[:max_seller_rating] = 9999999
		@params[:sort] = Hash.new; @params[:sort][:commissionRateUp] = 1
		@params[:hot_products] = Hash.new; @params[:hot_products][:yesno] = 0
		@url = "https://gw.api.alibaba.com/openapi/param2/2/portals.open"
	end
	
	# 1 - Search in Aliexpress Api methods/helper

	describe '.search_url_generator' do
		it 'receives valid parameters' do
			expect(@params[:keyword]).to be_a(String)
			expect(@params[:sort][:commissionRateUp]).to be_between(0,1)
			expect(@params[:category][:fields][1]).to be_a(Numeric)
			expect(@params[:min_seller_rating]).to be < @params[:max_seller_rating]
		end

		it 'create url to access Aliexpress API' do
			expect(@url).to include("https://gw.api.alibaba.com/openapi/param2/2/portals.open")
		end

		it 'return 2001000 error code from make_call method' do
			expect(described_class.search_url_generator(@params)["errorCode"]).to be == 20010000
		end
	end

	describe '.search_for_category_items' do
		it 'got valid keyword' do
			expect(@params[:keyword]).to be_a(String)
		end

		it 'got valid category id' do
			expect(@params[:category][:fields][1]).to be_a(Numeric)
		end

		it 'create url to access Aliexpress API' do
			expect(@url).to include("https://gw.api.alibaba.com/openapi/param2/2/portals.open")
		end

		it 'return 2001000 error code from make_call method' do
			expect(described_class.search_for_category_items(@params[:keyword],@params[:category][:fields][1])["errorCode"]).to be == 20010000
		end
	end


	#--------------------------------- 1 - END ---------------------------------

	# 2 -  Find hot/similar products

	describe '.get_hot_products' do

		currency = "usd"
		category =	5090301
		language = "en"

		it "got valid currency" do
			expect(currency.length).to be == 3
		end

		it "got valid category id" do
			expect(category).to be_a(Numeric)
		end

		it "got valid language" do
			expect(language.length).to be == 2
		end

		it 'create url to access Aliexpress API' do
			expect(@url).to include("https://gw.api.alibaba.com/openapi/param2/2/portals.open")
		end

		it 'return 2001000 error code from make_call method' do
			expect(described_class.get_hot_products(currency,category,language)["errorCode"]).to be == 20010000
		end

	end

	#actually disabled by Aliexpress
	#describe '.get_similar_products' do
		#productId = 32798037929

		#it "got valid product Id" do
		#	expect(productId).to be_a(Numeric)
		#end

		#it 'create url to find similar products' do
		#	expect(@url).to include("https://gw.api.alibaba.com/openapi/param2/2/portals.open")
		#end

		#it 'return 2001000 error code from make_call method' do
		#	expect(described_class.get_similar_products(productId)["errorCode"]).to be == 20010000
		#end
	#end
	

	#--------------------------- 2 - END --------------------------------------

	# 3 - Get product details from aliexpress api

	describe '.get_product_details' do

		productId = 32798037929
		fields = ['productId','productTitle']

		it "has got valid product Id" do
			expect(productId).to be_a(Numeric)
		end

		it "has got fields list" do
			expect(fields).not_to be nil
		end

		it 'has created url to find details of product on ALiexpress' do
			expect(@url).to include("https://gw.api.alibaba.com/openapi/param2/2/portals.open")
		end

		it 'returned 2001000 code after connecting to Aliexpress API using make_call method' do
			expect(described_class.get_product_details(fields,productId)["errorCode"]).to be == 20010000
		end
	end

	describe '.get_promotion_links' do

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

		it 'has created url to generate affilate links of given products using Aliexpress API' do
			expect(@url).to include("https://gw.api.alibaba.com/openapi/param2/2/portals.open")
		end

		it 'return 2001000 error code from make_call method' do
			product_url = "https://www.aliexpress.com/item/Girls-Dress-2016-Summer-Chiffon-Party-Dress-Infant-1-Year-Birthday-Dress-Baby-Girl-Clothing-Dresses/32691146516.html"
			expect(described_class.get_promotion_links(product_url)["errorCode"]).to be == 20010000
		end
	end

	#-------------------------------- 3 - END -------------------------------

	# 4 - Fetch product details

	describe '.fetch_product_details' do
		#this method uses watir to browse aliexpress, came back here later when you will be better with testing
	end


	#-------------------------------- 4 - END -------------------------------
end