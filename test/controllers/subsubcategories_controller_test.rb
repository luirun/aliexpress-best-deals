require 'test_helper'

class SubsubcategoriesControllerTest < ActionController::TestCase
  setup do
    @subsubcategory = subsubcategories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:subsubcategories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create subsubcategory" do
    assert_difference('Subsubcategory.count') do
      post :create, subsubcategory: { name: @subsubcategory.name, parent: @subsubcategory.parent }
    end

    assert_redirected_to subsubcategory_path(assigns(:subsubcategory))
  end

  test "should show subsubcategory" do
    get :show, id: @subsubcategory
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @subsubcategory
    assert_response :success
  end

  test "should update subsubcategory" do
    patch :update, id: @subsubcategory, subsubcategory: { name: @subsubcategory.name, parent: @subsubcategory.parent }
    assert_redirected_to subsubcategory_path(assigns(:subsubcategory))
  end

  test "should destroy subsubcategory" do
    assert_difference('Subsubcategory.count', -1) do
      delete :destroy, id: @subsubcategory
    end

    assert_redirected_to subsubcategories_path
  end
end
