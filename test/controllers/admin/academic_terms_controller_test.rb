require 'test_helper'

class Admin::AcademicTermsControllerTest < ActionController::TestCase
  setup do
    @academic_term = academic_terms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:academic_terms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create academic_term" do
    assert_difference('AcademicTerm.count') do
      post :create, academic_term: {  }
    end

    assert_redirected_to academic_term_path(assigns(:academic_term))
  end

  test "should show academic_term" do
    get :show, id: @academic_term
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @academic_term
    assert_response :success
  end

  test "should update academic_term" do
    patch :update, id: @academic_term, academic_term: {  }
    assert_redirected_to academic_term_path(assigns(:academic_term))
  end

  test "should destroy academic_term" do
    assert_difference('AcademicTerm.count', -1) do
      delete :destroy, id: @academic_term
    end

    assert_redirected_to academic_terms_path
  end
end
