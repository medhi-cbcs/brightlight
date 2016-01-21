require 'test_helper'

class CopyConditionsControllerTest < ActionController::TestCase
  setup do
    @copy_condition = copy_conditions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:copy_conditions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create copy_condition" do
    assert_difference('CopyCondition.count') do
      post :create, copy_condition: { academic_year_id: @copy_condition.academic_year_id, barcode: @copy_condition.barcode, book_condition_id: @copy_condition.book_condition_id, book_copy_id: @copy_condition.book_copy_id, end_date: @copy_condition.end_date, notes: @copy_condition.notes, start_date: @copy_condition.start_date, user_id: @copy_condition.user_id }
    end

    assert_redirected_to copy_condition_path(assigns(:copy_condition))
  end

  test "should show copy_condition" do
    get :show, id: @copy_condition
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @copy_condition
    assert_response :success
  end

  test "should update copy_condition" do
    patch :update, id: @copy_condition, copy_condition: { academic_year_id: @copy_condition.academic_year_id, barcode: @copy_condition.barcode, book_condition_id: @copy_condition.book_condition_id, book_copy_id: @copy_condition.book_copy_id, end_date: @copy_condition.end_date, notes: @copy_condition.notes, start_date: @copy_condition.start_date, user_id: @copy_condition.user_id }
    assert_redirected_to copy_condition_path(assigns(:copy_condition))
  end

  test "should destroy copy_condition" do
    assert_difference('CopyCondition.count', -1) do
      delete :destroy, id: @copy_condition
    end

    assert_redirected_to copy_conditions_path
  end
end
