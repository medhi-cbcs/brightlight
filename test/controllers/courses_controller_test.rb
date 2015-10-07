require 'test_helper'

class CoursesControllerTest < ActionController::TestCase
  setup do
    @course = courses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:courses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create course" do
    assert_difference('Course.count') do
      post :create, course: { academic_term_id: @course.academic_term_id, academic_year_id: @course.academic_year_id, description: @course.description, employee_id: @course.employee_id, grade_level_id: @course.grade_level_id, name: @course.name, number: @course.number }
    end

    assert_redirected_to course_path(assigns(:course))
  end

  test "should show course" do
    get :show, id: @course
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @course
    assert_response :success
  end

  test "should update course" do
    patch :update, id: @course, course: { academic_term_id: @course.academic_term_id, academic_year_id: @course.academic_year_id, description: @course.description, employee_id: @course.employee_id, grade_level_id: @course.grade_level_id, name: @course.name, number: @course.number }
    assert_redirected_to course_path(assigns(:course))
  end

  test "should destroy course" do
    assert_difference('Course.count', -1) do
      delete :destroy, id: @course
    end

    assert_redirected_to courses_path
  end
end
