require 'test_helper'

class BookFinesControllerTest < ActionController::TestCase
  setup do
    @book_fine = book_fines(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:book_fines)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create book_fine" do
    assert_difference('BookFine.count') do
      post :create, book_fine: { academic_year_id: @book_fine.academic_year_id, book_copy_id: @book_fine.book_copy_id, fine: @book_fine.fine, new_condition_id: @book_fine.new_condition_id, old_condition_id: @book_fine.old_condition_id, status: @book_fine.status, student_id: @book_fine.student_id }
    end

    assert_redirected_to book_fine_path(assigns(:book_fine))
  end

  test "should show book_fine" do
    get :show, id: @book_fine
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @book_fine
    assert_response :success
  end

  test "should update book_fine" do
    patch :update, id: @book_fine, book_fine: { academic_year_id: @book_fine.academic_year_id, book_copy_id: @book_fine.book_copy_id, fine: @book_fine.fine, new_condition_id: @book_fine.new_condition_id, old_condition_id: @book_fine.old_condition_id, status: @book_fine.status, student_id: @book_fine.student_id }
    assert_redirected_to book_fine_path(assigns(:book_fine))
  end

  test "should destroy book_fine" do
    assert_difference('BookFine.count', -1) do
      delete :destroy, id: @book_fine
    end

    assert_redirected_to book_fines_path
  end
end
