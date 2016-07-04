require 'test_helper'

class GradeSectionHistoriesControllerTest < ActionController::TestCase
  setup do
    @grade_section_history = grade_section_histories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:grade_section_histories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create grade_section_history" do
    assert_difference('GradeSectionHistory.count') do
      post :create, grade_section_history: { index: @grade_section_history.index, show: @grade_section_history.show }
    end

    assert_redirected_to grade_section_history_path(assigns(:grade_section_history))
  end

  test "should show grade_section_history" do
    get :show, id: @grade_section_history
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @grade_section_history
    assert_response :success
  end

  test "should update grade_section_history" do
    patch :update, id: @grade_section_history, grade_section_history: { index: @grade_section_history.index, show: @grade_section_history.show }
    assert_redirected_to grade_section_history_path(assigns(:grade_section_history))
  end

  test "should destroy grade_section_history" do
    assert_difference('GradeSectionHistory.count', -1) do
      delete :destroy, id: @grade_section_history
    end

    assert_redirected_to grade_section_histories_path
  end
end
