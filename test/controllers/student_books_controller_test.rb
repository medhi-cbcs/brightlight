require 'test_helper'

class StudentBooksControllerTest < ActionController::TestCase
  setup do
    @student_book = student_books(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:student_books)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create student_book" do
    assert_difference('StudentBook.count') do
      post :create, student_book: { academic_year_id: @student_book.academic_year_id, book_copy_id: @student_book.book_copy_id, copy_no: @student_book.copy_no, course_id: @student_book.course_id, course_text_id: @student_book.course_text_id, course_text_id: @student_book.course_text_id, end_copy_condition_id: @student_book.end_copy_condition_id, grade_level_id: @student_book.grade_level_id, grade_section_id: @student_book.grade_section_id, initial_copy_condition_id: @student_book.initial_copy_condition_id, issue_date: @student_book.issue_date, return_date: @student_book.return_date, student_id: @student_book.student_id }
    end

    assert_redirected_to student_book_path(assigns(:student_book))
  end

  test "should show student_book" do
    get :show, id: @student_book
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @student_book
    assert_response :success
  end

  test "should update student_book" do
    patch :update, id: @student_book, student_book: { academic_year_id: @student_book.academic_year_id, book_copy_id: @student_book.book_copy_id, copy_no: @student_book.copy_no, course_id: @student_book.course_id, course_text_id: @student_book.course_text_id, course_text_id: @student_book.course_text_id, end_copy_condition_id: @student_book.end_copy_condition_id, grade_level_id: @student_book.grade_level_id, grade_section_id: @student_book.grade_section_id, initial_copy_condition_id: @student_book.initial_copy_condition_id, issue_date: @student_book.issue_date, return_date: @student_book.return_date, student_id: @student_book.student_id }
    assert_redirected_to student_book_path(assigns(:student_book))
  end

  test "should destroy student_book" do
    assert_difference('StudentBook.count', -1) do
      delete :destroy, id: @student_book
    end

    assert_redirected_to student_books_path
  end
end
