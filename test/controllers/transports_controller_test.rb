require 'test_helper'

class TransportsControllerTest < ActionController::TestCase
  setup do
    @transport = transports(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:transports)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create transport" do
    assert_difference('Transport.count') do
      post :create, transport: { active: @transport.active, contact_email: @transport.contact_email, contact_id: @transport.contact_id, contact_name: @transport.contact_name, contact_phone: @transport.contact_phone, name: @transport.name, notes: @transport.notes, status: @transport.status, type: @transport.type }
    end

    assert_redirected_to transport_path(assigns(:transport))
  end

  test "should show transport" do
    get :show, id: @transport
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @transport
    assert_response :success
  end

  test "should update transport" do
    patch :update, id: @transport, transport: { active: @transport.active, contact_email: @transport.contact_email, contact_id: @transport.contact_id, contact_name: @transport.contact_name, contact_phone: @transport.contact_phone, name: @transport.name, notes: @transport.notes, status: @transport.status, type: @transport.type }
    assert_redirected_to transport_path(assigns(:transport))
  end

  test "should destroy transport" do
    assert_difference('Transport.count', -1) do
      delete :destroy, id: @transport
    end

    assert_redirected_to transports_path
  end
end
