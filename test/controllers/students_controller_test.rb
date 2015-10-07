require 'test_helper'

class StudentsControllerTest < ActionController::TestCase
  setup do
    @student = students(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:students)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create student" do
    assert_difference('Student.count') do
      post :create, student: { address_line1: @student.address_line1, address_line2: @student.address_line2, admission_no: @student.admission_no, blood_type: @student.blood_type, city: @student.city, country: @student.country, date_of_birth: @student.date_of_birth, email: @student.email, enrollment_date: @student.enrollment_date, family_id: @student.family_id, first_name: @student.first_name, gender: @student.gender, home_phone: @student.home_phone, is_active: @student.is_active, is_deleted: @student.is_deleted, last_name: @student.last_name, mobile_phone: @student.mobile_phone, name: @student.name, nationality: @student.nationality, passport_no: @student.passport_no, photo_uri: @student.photo_uri, postal_code: @student.postal_code, religion: @student.religion, state: @student.state, status: @student.status, status_description: @student.status_description, student_no: @student.student_no }
    end

    assert_redirected_to student_path(assigns(:student))
  end

  test "should show student" do
    get :show, id: @student
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @student
    assert_response :success
  end

  test "should update student" do
    patch :update, id: @student, student: { address_line1: @student.address_line1, address_line2: @student.address_line2, admission_no: @student.admission_no, blood_type: @student.blood_type, city: @student.city, country: @student.country, date_of_birth: @student.date_of_birth, email: @student.email, enrollment_date: @student.enrollment_date, family_id: @student.family_id, first_name: @student.first_name, gender: @student.gender, home_phone: @student.home_phone, is_active: @student.is_active, is_deleted: @student.is_deleted, last_name: @student.last_name, mobile_phone: @student.mobile_phone, name: @student.name, nationality: @student.nationality, passport_no: @student.passport_no, photo_uri: @student.photo_uri, postal_code: @student.postal_code, religion: @student.religion, state: @student.state, status: @student.status, status_description: @student.status_description, student_no: @student.student_no }
    assert_redirected_to student_path(assigns(:student))
  end

  test "should destroy student" do
    assert_difference('Student.count', -1) do
      delete :destroy, id: @student
    end

    assert_redirected_to students_path
  end
end
