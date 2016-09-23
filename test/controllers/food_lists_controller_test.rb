require 'test_helper'

class FoodListsControllerTest < ActionController::TestCase
  setup do
    @food_list = food_lists(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:food_lists)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create food_list" do
    assert_difference('FoodList.count') do
      post :create, food_list: { name: @food_list.name, notes: @food_list.notes, picture_url: @food_list.picture_url }
    end

    assert_redirected_to food_list_path(assigns(:food_list))
  end

  test "should show food_list" do
    get :show, id: @food_list
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @food_list
    assert_response :success
  end

  test "should update food_list" do
    patch :update, id: @food_list, food_list: { name: @food_list.name, notes: @food_list.notes, picture_url: @food_list.picture_url }
    assert_redirected_to food_list_path(assigns(:food_list))
  end

  test "should destroy food_list" do
    assert_difference('FoodList.count', -1) do
      delete :destroy, id: @food_list
    end

    assert_redirected_to food_lists_path
  end
end
