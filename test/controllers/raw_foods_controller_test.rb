require 'test_helper'

class RawFoodsControllerTest < ActionController::TestCase
  setup do
    @raw_food = raw_foods(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:raw_foods)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create raw_food" do
    assert_difference('RawFood.count') do
      post :create, raw_food: { brand: @raw_food.brand, kind: @raw_food.kind, min_stock: @raw_food.min_stock, name: @raw_food.name, raw_unit_id: @raw_food.raw_unit_id }
    end

    assert_redirected_to raw_food_path(assigns(:raw_food))
  end

  test "should show raw_food" do
    get :show, id: @raw_food
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @raw_food
    assert_response :success
  end

  test "should update raw_food" do
    patch :update, id: @raw_food, raw_food: { brand: @raw_food.brand, kind: @raw_food.kind, min_stock: @raw_food.min_stock, name: @raw_food.name, raw_unit_id: @raw_food.raw_unit_id }
    assert_redirected_to raw_food_path(assigns(:raw_food))
  end

  test "should destroy raw_food" do
    assert_difference('RawFood.count', -1) do
      delete :destroy, id: @raw_food
    end

    assert_redirected_to raw_foods_path
  end
end
