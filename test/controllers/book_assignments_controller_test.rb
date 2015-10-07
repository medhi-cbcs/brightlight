require 'test_helper'

class BookAssignmentsControllerTest < ActionController::TestCase
  setup do
    @book_assignment = book_assignments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:book_assignments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create book_assignment" do
    assert_difference('BookAssignment.count') do
      post :create, book_assignment: { academic_year_id: @book_assignment.academic_year_id, book_id: @book_assignment.book_id, course_text_id: @book_assignment.course_text_id, end_condition_id: @book_assignment.end_condition_id, initial_condition_id: @book_assignment.initial_condition_id, issue_date: @book_assignment.issue_date, return_date: @book_assignment.return_date, status_id: @book_assignment.status_id, student_id: @book_assignment.student_id }
    end

    assert_redirected_to book_assignment_path(assigns(:book_assignment))
  end

  test "should show book_assignment" do
    get :show, id: @book_assignment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @book_assignment
    assert_response :success
  end

  test "should update book_assignment" do
    patch :update, id: @book_assignment, book_assignment: { academic_year_id: @book_assignment.academic_year_id, book_id: @book_assignment.book_id, course_text_id: @book_assignment.course_text_id, end_condition_id: @book_assignment.end_condition_id, initial_condition_id: @book_assignment.initial_condition_id, issue_date: @book_assignment.issue_date, return_date: @book_assignment.return_date, status_id: @book_assignment.status_id, student_id: @book_assignment.student_id }
    assert_redirected_to book_assignment_path(assigns(:book_assignment))
  end

  test "should destroy book_assignment" do
    assert_difference('BookAssignment.count', -1) do
      delete :destroy, id: @book_assignment
    end

    assert_redirected_to book_assignments_path
  end
end
