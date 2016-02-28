require 'test_helper'

class PeopleControllerTest < ActionController::TestCase
  setup do
    @person = people(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:people)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create person" do
    assert_difference('Person.count') do
      post :create, person: { address_line1: @person.address_line1, address_line2: @person.address_line2, bbm_pin: @person.bbm_pin, blood_type: @person.blood_type, city: @person.city, country: @person.country, date_of_birth: @person.date_of_birth, email: @person.email, first_name: @person.first_name, full_name: @person.full_name, gender: @person.gender, gravatar: @person.gravatar, home_phone: @person.home_phone, kabupaten: @person.kabupaten, kecamatan: @person.kecamatan, last_name: @person.last_name, mobile_phone: @person.mobile_phone, nationality: @person.nationality, nick_name: @person.nick_name, other_email: @person.other_email, other_phone: @person.other_phone, passport_no: @person.passport_no, photo_uri: @person.photo_uri, place_of_birth: @person.place_of_birth, postal_code: @person.postal_code, religion: @person.religion, sm_facebook: @person.sm_facebook, sm_google_plus: @person.sm_google_plus, sm_instagram: @person.sm_instagram, sm_line: @person.sm_line, sm_linked_in: @person.sm_linked_in, sm_path: @person.sm_path, state: @person.state, wm_twitter: @person.wm_twitter }
    end

    assert_redirected_to person_path(assigns(:person))
  end

  test "should show person" do
    get :show, id: @person
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @person
    assert_response :success
  end

  test "should update person" do
    patch :update, id: @person, person: { address_line1: @person.address_line1, address_line2: @person.address_line2, bbm_pin: @person.bbm_pin, blood_type: @person.blood_type, city: @person.city, country: @person.country, date_of_birth: @person.date_of_birth, email: @person.email, first_name: @person.first_name, full_name: @person.full_name, gender: @person.gender, gravatar: @person.gravatar, home_phone: @person.home_phone, kabupaten: @person.kabupaten, kecamatan: @person.kecamatan, last_name: @person.last_name, mobile_phone: @person.mobile_phone, nationality: @person.nationality, nick_name: @person.nick_name, other_email: @person.other_email, other_phone: @person.other_phone, passport_no: @person.passport_no, photo_uri: @person.photo_uri, place_of_birth: @person.place_of_birth, postal_code: @person.postal_code, religion: @person.religion, sm_facebook: @person.sm_facebook, sm_google_plus: @person.sm_google_plus, sm_instagram: @person.sm_instagram, sm_line: @person.sm_line, sm_linked_in: @person.sm_linked_in, sm_path: @person.sm_path, state: @person.state, wm_twitter: @person.wm_twitter }
    assert_redirected_to person_path(assigns(:person))
  end

  test "should destroy person" do
    assert_difference('Person.count', -1) do
      delete :destroy, id: @person
    end

    assert_redirected_to people_path
  end
end
