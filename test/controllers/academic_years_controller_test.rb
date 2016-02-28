require 'test_helper'

class AcademicYearsControllerTest < ActionController::TestCase
  setup do
    @academic_year = academic_years(:current)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:academic_years)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create academic_year" do
    assert_difference('AcademicYear.count') do
      post :create, academic_year: {  }
    end

    assert_redirected_to academic_year_path(assigns(:academic_year))
  end

  test "should show academic_year" do
    get :show, id: @academic_year
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @academic_year
    assert_response :success
  end

  test "should update academic_year" do
    patch :update, id: @academic_year, academic_year: {  }
    assert_redirected_to academic_year_path(assigns(:academic_year))
  end

  test "should destroy academic_year" do
    assert_difference('AcademicYear.count', -1) do
      delete :destroy, id: @academic_year
    end

    assert_redirected_to academic_years_path
  end
end
