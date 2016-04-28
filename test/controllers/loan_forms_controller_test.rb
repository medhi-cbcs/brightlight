require 'test_helper'

class LoanFormsControllerTest < ActionController::TestCase
  setup do
    @loan_form = loan_forms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:loan_forms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create loan_form" do
    assert_difference('LoanForm.count') do
      post :create, loan_form: {  }
    end

    assert_redirected_to loan_form_path(assigns(:loan_form))
  end

  test "should show loan_form" do
    get :show, id: @loan_form
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @loan_form
    assert_response :success
  end

  test "should update loan_form" do
    patch :update, id: @loan_form, loan_form: {  }
    assert_redirected_to loan_form_path(assigns(:loan_form))
  end

  test "should destroy loan_form" do
    assert_difference('LoanForm.count', -1) do
      delete :destroy, id: @loan_form
    end

    assert_redirected_to loan_forms_path
  end
end
