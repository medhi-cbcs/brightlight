require 'test_helper'

class GradeSectionsControllerTest < ActionController::TestCase
  setup do
    @grade_section = grade_sections(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:grade_sections)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create grade_section" do
    assert_difference('GradeSection.count') do
      post :create, grade_section: {  }
    end

    assert_redirected_to grade_section_path(assigns(:grade_section))
  end

  test "should show grade_section" do
    get :show, id: @grade_section
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @grade_section
    assert_response :success
  end

  test "should update grade_section" do
    patch :update, id: @grade_section, grade_section: {  }
    assert_redirected_to grade_section_path(assigns(:grade_section))
  end

  test "should destroy grade_section" do
    assert_difference('GradeSection.count', -1) do
      delete :destroy, id: @grade_section
    end

    assert_redirected_to grade_sections_path
  end
end
