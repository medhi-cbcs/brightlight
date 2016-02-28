require 'test_helper'

class BookLoansControllerTest < ActionController::TestCase
  setup do
    @book_loan = book_loans(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:book_loans)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create book_loan" do
    assert_difference('BookLoan.count') do
      post :create, book_loan: { academic_year_id: @book_loan.academic_year_id, book_category_id: @book_loan.book_category_id, book_copy_id: @book_loan.book_copy_id, book_edition_id: @book_loan.book_edition_id, book_title_id: @book_loan.book_title_id, due_date: @book_loan.due_date, loan_type_id: @book_loan.loan_type_id, out_date: @book_loan.out_date, user_id: @book_loan.user_id }
    end

    assert_redirected_to book_loan_path(assigns(:book_loan))
  end

  test "should show book_loan" do
    get :show, id: @book_loan
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @book_loan
    assert_response :success
  end

  test "should update book_loan" do
    patch :update, id: @book_loan, book_loan: { academic_year_id: @book_loan.academic_year_id, book_category_id: @book_loan.book_category_id, book_copy_id: @book_loan.book_copy_id, book_edition_id: @book_loan.book_edition_id, book_title_id: @book_loan.book_title_id, due_date: @book_loan.due_date, loan_type_id: @book_loan.loan_type_id, out_date: @book_loan.out_date, user_id: @book_loan.user_id }
    assert_redirected_to book_loan_path(assigns(:book_loan))
  end

  test "should destroy book_loan" do
    assert_difference('BookLoan.count', -1) do
      delete :destroy, id: @book_loan
    end

    assert_redirected_to book_loans_path
  end
end
