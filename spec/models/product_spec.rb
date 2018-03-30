require 'rails_helper'

describe Product do

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

end