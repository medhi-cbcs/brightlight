require 'test_helper'

class BookGradesControllerTest < ActionController::TestCase
  setup do
    @book_grade = book_grades(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:book_grades)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create book_grade" do
    assert_difference('BookGrade.count') do
      post :create, book_grade: { academic_year_id: @book_grade.academic_year_id, book_condition_id: @book_grade.book_condition_id, book_id: @book_grade.book_id, graded_by: @book_grade.graded_by, notes: @book_grade.notes, notes: @book_grade.notes }
    end

    assert_redirected_to book_grade_path(assigns(:book_grade))
  end

  test "should show book_grade" do
    get :show, id: @book_grade
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @book_grade
    assert_response :success
  end

  test "should update book_grade" do
    patch :update, id: @book_grade, book_grade: { academic_year_id: @book_grade.academic_year_id, book_condition_id: @book_grade.book_condition_id, book_id: @book_grade.book_id, graded_by: @book_grade.graded_by, notes: @book_grade.notes, notes: @book_grade.notes }
    assert_redirected_to book_grade_path(assigns(:book_grade))
  end

  test "should destroy book_grade" do
    assert_difference('BookGrade.count', -1) do
      delete :destroy, id: @book_grade
    end

    assert_redirected_to book_grades_path
  end
end
