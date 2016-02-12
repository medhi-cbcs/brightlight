require 'test_helper'

class GuardiansControllerTest < ActionController::TestCase
  setup do
    @guardian = guardians(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:guardians)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create guardian" do
    assert_difference('Guardian.count') do
      post :create, guardian: { address_line1: @guardian.address_line1, address_line2: @guardian.address_line2, city: @guardian.city, country: @guardian.country, family_no: @guardian.family_no, first_name: @guardian.first_name, home_phone: @guardian.home_phone, last_name: @guardian.last_name, mobile_phone: @guardian.mobile_phone, name: @guardian.name, office_phone: @guardian.office_phone, other_phone: @guardian.other_phone, postal_code: @guardian.postal_code, state: @guardian.state }
    end

    assert_redirected_to guardian_path(assigns(:guardian))
  end

  test "should show guardian" do
    get :show, id: @guardian
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @guardian
    assert_response :success
  end

  test "should update guardian" do
    patch :update, id: @guardian, guardian: { address_line1: @guardian.address_line1, address_line2: @guardian.address_line2, city: @guardian.city, country: @guardian.country, family_no: @guardian.family_no, first_name: @guardian.first_name, home_phone: @guardian.home_phone, last_name: @guardian.last_name, mobile_phone: @guardian.mobile_phone, name: @guardian.name, office_phone: @guardian.office_phone, other_phone: @guardian.other_phone, postal_code: @guardian.postal_code, state: @guardian.state }
    assert_redirected_to guardian_path(assigns(:guardian))
  end

  test "should destroy guardian" do
    assert_difference('Guardian.count', -1) do
      delete :destroy, id: @guardian
    end

    assert_redirected_to guardians_path
  end
end
