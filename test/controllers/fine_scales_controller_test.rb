require 'test_helper'

class FineScalesControllerTest < ActionController::TestCase
  setup do
    @fine_scale = fine_scales(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fine_scales)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fine_scale" do
    assert_difference('FineScale.count') do
      post :create, fine_scale: { fine_scale: @fine_scale.percentage, new_condition_id_id: @fine_scale.new_condition_id_id, old_condition_id_id: @fine_scale.old_condition_id_id }
    end

    assert_redirected_to fine_scale_path(assigns(:fine_scale))
  end

  test "should show fine_scale" do
    get :show, id: @fine_scale
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @fine_scale
    assert_response :success
  end

  test "should update fine_scale" do
    patch :update, id: @fine_scale, fine_scale: { fine_scale: @fine_scale.fine_scale, new_condition_id_id: @fine_scale.new_condition_id_id, old_condition_id_id: @fine_scale.old_condition_id_id }
    assert_redirected_to fine_scale_path(assigns(:fine_scale))
  end

  test "should destroy fine_scale" do
    assert_difference('FineScale.count', -1) do
      delete :destroy, id: @fine_scale
    end

    assert_redirected_to fine_scales_path
  end
end
