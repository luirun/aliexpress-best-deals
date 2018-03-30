require 'rails_helper'
require 'devise'

RSpec.describe AdminsController, :type => :controller do

  before(:each) do
    login_user
  end

  describe '#GET search_for_products' do
    it "should redirect to #list_found_products after submitting form" do
      visit admins_path
      #find_by_id('category_fields').find("option[value='509']").click
      #find("option[value='509']").select_option
      fill_in 'keyword', with: 'xiaomi'
      click_button 'Submit'
      expect(page).to have_content 'Success'
    end
  end

  describe 'POST #list_items' do

  end

  describe 'POST #save_items' do

  end

  # ---------------------------- 1 end -----------------------------------

  # 2 - search hot products(high quality products) by category

  # /hot_products_by_category [FORM HERE] -> /hot_products_by_category [POST]
  describe 'POST #save_hot_products_by_category' do

  end

  # ---------------------------- 2 end -----------------------------------

  # 3 - search for all hot products
  # /auto_save_hot_products -> /auto_save_hot_products [POST] 
  describe 'POST #auto_hot_products' do

  end

  describe 'GET #mass_subcategory_filling' do

  end

  # ---------------------------- 3 end -----------------------------------

  # 4 - various clearing
  # /clear_expired_items => here => Item.clear_expired_items
  describe 'GET #clear_expired_items' do

  end

  describe 'GET #delete_empty_reviews' do

  end

  # ---------------------------- 4 end -----------------------------------


  # 5 - comment manager
  # /comments_manager [FORM] -> /comments_manager_update [POST]
  describe 'GET #comments_manager' do

  end

  describe 'POST #comments_manager_update' do

  end

  # ---------------------------- 5 end -----------------------------------

  # 6 - fill category from file
  # fill_category_from_file [FORM] -> /save_from_file [POST]
  describe 'POST #save_from_file' do

  end

  #---------------------------- 6 end -----------------------------------


  # 7 - fetch product details
  describe 'GET #update_products_details' do

  end

  #---------------------------- 7 end -----------------------------------

  # undone yet
  # article manager
end
