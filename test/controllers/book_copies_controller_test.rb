require 'test_helper'

class BookCopiesControllerTest < ActionController::TestCase
  setup do
    @book_copy = book_copies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:book_copies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create book_copy" do
    assert_difference('BookCopy.count') do
      post :create, book_copy: { barcode: @book_copy.barcode, book_condition_id: @book_copy.book_condition_id, book_edition_id: @book_copy.book_edition_id, copy_no: @book_copy.copy_no, status_id: @book_copy.status_id }
    end

    assert_redirected_to book_copy_path(assigns(:book_copy))
  end

  test "should show book_copy" do
    get :show, id: @book_copy
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @book_copy
    assert_response :success
  end

  test "should update book_copy" do
    patch :update, id: @book_copy, book_copy: { barcode: @book_copy.barcode, book_condition_id: @book_copy.book_condition_id, book_edition_id: @book_copy.book_edition_id, copy_no: @book_copy.copy_no, status_id: @book_copy.status_id }
    assert_redirected_to book_copy_path(assigns(:book_copy))
  end

  test "should destroy book_copy" do
    assert_difference('BookCopy.count', -1) do
      delete :destroy, id: @book_copy
    end

    assert_redirected_to book_copies_path
  end
end
