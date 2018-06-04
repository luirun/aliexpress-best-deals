require 'rails_helper'

describe ProductLike do

  before(:each) do
    create(:category)
    create(:subcategory)
    create(:product)
  end

  describe '.create_like' do
    context 'recives not unqiue product and user Id' do
      let(:like) { create(:product_like) }
      it 'warn administrator that unwanted action was allowed by UI' do
        expect(Rails.logger).to receive(:fatal).with("This action shouldn't be allowed from UI!")
        described_class.create_like(like.product_id, like.user_id, like.user_cookie_id)
      end
    end

    context 'recives unique product and user ID' do
      let(:like) { FactoryBot.build(:product_like) }
      it 'saves product like to database' do
        expect { described_class.create_like(like.product_id, like.user_id, like.user_cookie_id) } .to change{ ProductLike.all.size }.by(1)
      end
    end
  end

  describe '.destroy_like' do

  end
end