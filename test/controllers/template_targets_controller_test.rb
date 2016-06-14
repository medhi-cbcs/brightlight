require 'test_helper'

class TemplateTargetsControllerTest < ActionController::TestCase
  setup do
    @template_target = template_targets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:template_targets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create template_target" do
    assert_difference('TemplateTarget.count') do
      post :create, template_target: { code: @template_target.code, description: @template_target.description, name: @template_target.name }
    end

    assert_redirected_to template_target_path(assigns(:template_target))
  end

  test "should show template_target" do
    get :show, id: @template_target
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @template_target
    assert_response :success
  end

  test "should update template_target" do
    patch :update, id: @template_target, template_target: { code: @template_target.code, description: @template_target.description, name: @template_target.name }
    assert_redirected_to template_target_path(assigns(:template_target))
  end

  test "should destroy template_target" do
    assert_difference('TemplateTarget.count', -1) do
      delete :destroy, id: @template_target
    end

    assert_redirected_to template_targets_path
  end
end
