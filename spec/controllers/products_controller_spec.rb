require 'rails_helper'
require 'devise'
RSpec.describe ProductsController do
  render_views
  
  describe 'GET index' do
    it 'show all categories' do
      @categories = FactoryGirl.create(:category)
      get :index
      expect(response.body).to have_content("Find products by category:")
    end
  end

end
