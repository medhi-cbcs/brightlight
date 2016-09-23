require 'test_helper'

class RawUnitsControllerTest < ActionController::TestCase
  setup do
    @raw_unit = raw_units(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:raw_units)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create raw_unit" do
    assert_difference('RawUnit.count') do
      post :create, raw_unit: { name: @raw_unit.name, notes: @raw_unit.notes }
    end

    assert_redirected_to raw_unit_path(assigns(:raw_unit))
  end

  test "should show raw_unit" do
    get :show, id: @raw_unit
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @raw_unit
    assert_response :success
  end

  test "should update raw_unit" do
    patch :update, id: @raw_unit, raw_unit: { name: @raw_unit.name, notes: @raw_unit.notes }
    assert_redirected_to raw_unit_path(assigns(:raw_unit))
  end

  test "should destroy raw_unit" do
    assert_difference('RawUnit.count', -1) do
      delete :destroy, id: @raw_unit
    end

    assert_redirected_to raw_units_path
  end
end
