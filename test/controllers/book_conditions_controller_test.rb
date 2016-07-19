require 'test_helper'

class BookConditionsControllerTest < ActionController::TestCase
  setup do
    @book_condition = book_conditions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:book_conditions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create book_condition" do
    assert_difference('BookCondition.count') do
      post :create, book_condition: {  }
    end

    assert_redirected_to book_condition_path(assigns(:book_condition))
  end

  test "should show book_condition" do
    get :show, id: @book_condition
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @book_condition
    assert_response :success
  end

  test "should update book_condition" do
    patch :update, id: @book_condition, book_condition: {  }
    assert_redirected_to book_condition_path(assigns(:book_condition))
  end

  test "should destroy book_condition" do
    assert_difference('BookCondition.count', -1) do
      delete :destroy, id: @book_condition
    end

    assert_redirected_to book_conditions_path
  end
end
