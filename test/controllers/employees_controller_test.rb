require 'test_helper'

class EmployeesControllerTest < ActionController::TestCase
  setup do
    @employee = employees(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:employees)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create employee" do
    assert_difference('Employee.count') do
      post :create, employee: { blood_type: @employee.blood_type, children_count: @employee.children_count, date_of_birth: @employee.date_of_birth, department_id: @employee.department_id, education_degree2: @employee.education_degree2, education_degree: @employee.education_degree, education_graduation_date2: @employee.education_graduation_date2, education_graduation_date: @employee.education_graduation_date, education_school2: @employee.education_school2, education_school: @employee.education_school, email: @employee.email, emergency_contact_name: @employee.emergency_contact_name, emergency_contact_number: @employee.emergency_contact_number, employee_number: @employee.employee_number, employment_status: @employee.employment_status, experience_month: @employee.experience_month, experience_year: @employee.experience_year, first_name: @employee.first_name, gender: @employee.gender, home_address_line1: @employee.home_address_line1, home_address_line2: @employee.home_address_line2, home_city: @employee.home_city, home_country: @employee.home_country, home_phone: @employee.home_phone, home_postal_code: @employee.home_postal_code, home_state: @employee.home_state, job_title: @employee.job_title, joining_date: @employee.joining_date, last_name: @employee.last_name, marital_status: @employee.marital_status, mobile_phone: @employee.mobile_phone, name: @employee.name, nationality: @employee.nationality, office_phone: @employee.office_phone, other_phone: @employee.other_phone, photo_uri: @employee.photo_uri, place_of_birth: @employee.place_of_birth, reporting_supervisor_id: @employee.reporting_supervisor_id }
    end

    assert_redirected_to employee_path(assigns(:employee))
  end

  test "should show employee" do
    get :show, id: @employee
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @employee
    assert_response :success
  end

  test "should update employee" do
    patch :update, id: @employee, employee: { blood_type: @employee.blood_type, children_count: @employee.children_count, date_of_birth: @employee.date_of_birth, department_id: @employee.department_id, education_degree2: @employee.education_degree2, education_degree: @employee.education_degree, education_graduation_date2: @employee.education_graduation_date2, education_graduation_date: @employee.education_graduation_date, education_school2: @employee.education_school2, education_school: @employee.education_school, email: @employee.email, emergency_contact_name: @employee.emergency_contact_name, emergency_contact_number: @employee.emergency_contact_number, employee_number: @employee.employee_number, employment_status: @employee.employment_status, experience_month: @employee.experience_month, experience_year: @employee.experience_year, first_name: @employee.first_name, gender: @employee.gender, home_address_line1: @employee.home_address_line1, home_address_line2: @employee.home_address_line2, home_city: @employee.home_city, home_country: @employee.home_country, home_phone: @employee.home_phone, home_postal_code: @employee.home_postal_code, home_state: @employee.home_state, job_title: @employee.job_title, joining_date: @employee.joining_date, last_name: @employee.last_name, marital_status: @employee.marital_status, mobile_phone: @employee.mobile_phone, name: @employee.name, nationality: @employee.nationality, office_phone: @employee.office_phone, other_phone: @employee.other_phone, photo_uri: @employee.photo_uri, place_of_birth: @employee.place_of_birth, reporting_supervisor_id: @employee.reporting_supervisor_id }
    assert_redirected_to employee_path(assigns(:employee))
  end

  test "should destroy employee" do
    assert_difference('Employee.count', -1) do
      delete :destroy, id: @employee
    end

    assert_redirected_to employees_path
  end
end
