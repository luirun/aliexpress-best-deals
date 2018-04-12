require 'rails_helper'

describe Product do

  after(:all) do
    Product.delete_all
  end

  describe '.ali_new' do
    category_id = 540
    products = Hash.new
    products["products"] = []

    it "got numeric category_id" do
      expect(category_id).to be_a(Numeric)
    end

    context "when no products passed as argument" do
      it 'return nil' do
        product = []
        expect(described_class.ali_new(product, category_id)).to be nil
      end
    end

    context "when one or more products passed as argument" do
      products["products"][0] = FactoryGirl.build(:product).attributes
      products["products"][0]["salePrice"] = "US $1.11"
      products["products"][0]["originalPrice"] = "US $1.11"

      it 'return Products successfully saved' do
        expect(described_class.ali_new(products["products"], category_id)).to eq "Products successfully saved!"
      end
    end
  end

  describe '.save_hot_products' do
    fields = %w[productId productTitle productUrl imageUrl
                originalPrice salePrice discount evaluateScore
                commission commissionRate 30daysCommission volume
                packageType lotNum validTime storeName storeUrl]
    category_id = 7
    subcategory_id = 702
    products = Hash.new
    products["products"] = []

    context "This product already exists" do
      it "save to logs that product already exist" do
        products["products"][0] = FactoryGirl.create(:product, productId: 1).attributes
        expect(Rails.logger).to receive(:info).with("Product Already Exists")
        described_class.save_hot_products(products["products"], category_id, subcategory_id)
      end
    end

    context "Product does not exist already" do
      context "Aliexpress API returned no details about this product" do
        products["products"][0] = FactoryGirl.build(:product, productId: 1).attributes
        it "save to logs information that Api returned no details" do
          expect(Rails.logger).to receive(:info).with(/We have not found any details about/)
          described_class.save_hot_products(products["products"], category_id, subcategory_id)
        end
      end

      context "Aliexpress API returned all details about this product" do
        it "save all recieved details of product" do
          products["products"][0] = FactoryGirl.build(:product).attributes
          described_class.save_hot_products(products["products"], category_id, subcategory_id)
          products_counter = Product.all.length
          expect(products_counter).to be >= 1
        end
      end
    end
  end

  describe ".save_product_description" do
    it "update given product with given description" do
      product = FactoryGirl.create(:product)
      product_description = "<div class='ui-box product-property-main'>    <div class='ui-box-title'>Item specifics</div>"
      described_class.save_product_description(product_description, product.id)

      product = Product.find(product.id)
      expect(product.productDescription).to eq(product_description)
    end
  end

  describe ".add_promotion_links" do
    context "passed not nil hash with promotion urls" do
      it "update given product with given promotion url" do
        FactoryGirl.create(:product, promotionUrl: nil)
        product = Product.all
        promotion_url = Array.new
        promotion_url[0] = {"promotionUrl" => FactoryGirl.build(:product).attributes["promotionUrl"]}
        described_class.add_promotion_links(promotion_url, product)

        product = Product.find(11)
        expect(product.promotionUrl).to eq(promotion_url[0]["promotionUrl"])
      end
    end
  end

  describe ".clear_unwanted_products" do

  end

  describe ".archive_expired_products" do
    it "marked as archived all products which validTime is older than today" do
      FactoryGirl.create(:product)
      described_class.archive_expired_products

      expect(Product.find(11).archived).to eq "y"
    end
  end

end