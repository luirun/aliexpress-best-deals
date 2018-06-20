require 'rails_helper'

describe Product do

  after(:all) do
    Product.delete_all
  end

  describe '#new_product' do
    category_id = 7
    let!(:products) { Hash.new }
    before do
      products["products"] = []

    end

    it "got numeric category_id" do
      expect(category_id).to be_a(Numeric)
    end

    context "when no products passed as argument" do
      it 'return nil' do
        product = []
        expect(described_class.new_product(product, category_id)).to be nil
      end
    end

    context "when one or more products passed as argument" do
      before do
        products["products"][0] = FactoryBot.build(:product).attributes
        products["products"][0]["salePrice"] = "US $1.11"
        products["products"][0]["originalPrice"] = "US $1.11"
      end

      it 'create new products' do
        expect {described_class.new_product(products["products"], category_id)}.to change { Product.count }
      end
    end
  end

  describe '#save_hot_products' do
    let!(:products) { Hash.new }
    let!(:category_id) { 7 }
    let!(:subcategory_id) { 702 }
    before(:each) do
      fields = %w[productId productTitle productUrl imageUrl
                  originalPrice salePrice discount evaluateScore
                  commission commissionRate 30daysCommission volume
                  packageType lotNum validTime storeName storeUrl]
      products["products"] = []
    end

    context "product already exists" do
      it "save to logs that product already exist" do
        products["products"][0] = FactoryBot.create(:product, productId: 1).attributes
        expect(Rails.logger).to receive(:info).with("Product Already Exists")
        described_class.save_hot_products(products["products"], category_id, subcategory_id)
      end
    end

    context "Product does not exist already" do
      context "Aliexpress API returned no details about this product" do
        it "save to logs information that Api returned no details" do
          products["products"][0] = FactoryBot.build(:product, productId: 1).attributes
          expect(Rails.logger).to receive(:info).with(/We have not found any details about/)
          described_class.save_hot_products(products["products"], category_id, subcategory_id)
        end
      end

      context "Aliexpress API returned all details about this product" do
        it "save all recieved details of product" do
          products["products"][0] = FactoryBot.build(:product).attributes
          expect { described_class.save_hot_products(products["products"], category_id, subcategory_id) }.to change { Product.count }
        end
      end
    end
  end

  describe "#save_product_description" do
    it "update given product with given description" do
      product = FactoryBot.create(:product)
      product_description = "<div class='ui-box product-property-main'>    <div class='ui-box-title'>Item specifics</div>"
      expect { described_class.save_product_description(product_description, product.id)}.to change { Product.find(product.id).productDescription }
    end
  end

  describe "#add_promotion_links" do
    let(:product) { FactoryBot.create(:product, promotionUrl: nil) }
    context "passed not nil hash with promotion urls" do
      it "update given product with given promotion url" do
        expect {described_class.add_promotion_links([product])}.to change { product.promotionUrl }
      end
    end
  end

  describe "#clear_unwanted_products" do
    # TODO
  end

  describe "#archive_expired_products" do
    let(:product) { FactoryBot.create(:product) }
    it "mark all products as archived which validTime is older than today" do
      expect { described_class.archive_expired_products }.to change { Product.find(product.id).archived }
    end
  end

end