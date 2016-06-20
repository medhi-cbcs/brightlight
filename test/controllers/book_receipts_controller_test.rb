require 'test_helper'

class BookReceiptsControllerTest < ActionController::TestCase
  setup do
    @book_receipt = book_receipts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:book_receipts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create book_receipt" do
    assert_difference('BookReceipt.count') do
      post :create, book_receipt: { academic_year_id: @book_receipt.academic_year_id, active: @book_receipt.active, barcode: @book_receipt.barcode, book_copy_id: @book_receipt.book_copy_id, book_edition_id: @book_receipt.book_edition_id, copy_no: @book_receipt.copy_no, course_id: @book_receipt.course_id, course_text_id: @book_receipt.course_text_id, grade_level_id: @book_receipt.grade_level_id, grade_section_code: @book_receipt.grade_section_code, grade_section_id: @book_receipt.grade_section_id, grade_subject_code: @book_receipt.grade_subject_code, initial_condition_id: @book_receipt.initial_condition_id, issue_date: @book_receipt.issue_date, notes: @book_receipt.notes, return_condition_id: @book_receipt.return_condition_id, roster_no: @book_receipt.roster_no, student_id: @book_receipt.student_id }
    end

    assert_redirected_to book_receipt_path(assigns(:book_receipt))
  end

  test "should show book_receipt" do
    get :show, id: @book_receipt
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @book_receipt
    assert_response :success
  end

  test "should update book_receipt" do
    patch :update, id: @book_receipt, book_receipt: { academic_year_id: @book_receipt.academic_year_id, active: @book_receipt.active, barcode: @book_receipt.barcode, book_copy_id: @book_receipt.book_copy_id, book_edition_id: @book_receipt.book_edition_id, copy_no: @book_receipt.copy_no, course_id: @book_receipt.course_id, course_text_id: @book_receipt.course_text_id, grade_level_id: @book_receipt.grade_level_id, grade_section_code: @book_receipt.grade_section_code, grade_section_id: @book_receipt.grade_section_id, grade_subject_code: @book_receipt.grade_subject_code, initial_condition_id: @book_receipt.initial_condition_id, issue_date: @book_receipt.issue_date, notes: @book_receipt.notes, return_condition_id: @book_receipt.return_condition_id, roster_no: @book_receipt.roster_no, student_id: @book_receipt.student_id }
    assert_redirected_to book_receipt_path(assigns(:book_receipt))
  end

  test "should destroy book_receipt" do
    assert_difference('BookReceipt.count', -1) do
      delete :destroy, id: @book_receipt
    end

    assert_redirected_to book_receipts_path
  end
end
