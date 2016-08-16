require 'test_helper'

class CarpoolsControllerTest < ActionController::TestCase
  setup do
    @carpool = carpools(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:carpools)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create carpool" do
    assert_difference('Carpool.count') do
      post :create, carpool: { active: @carpool.active, arrival: @carpool.arrival, barcode: @carpool.barcode, departure: @carpool.departure, notes: @carpool.notes, period: @carpool.period, sort_order: @carpool.sort_order, status: @carpool.status, transport_id: @carpool.transport_id, transport_name: @carpool.transport_name, type: @carpool.type }
    end

    assert_redirected_to carpool_path(assigns(:carpool))
  end

  test "should show carpool" do
    get :show, id: @carpool
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @carpool
    assert_response :success
  end

  test "should update carpool" do
    patch :update, id: @carpool, carpool: { active: @carpool.active, arrival: @carpool.arrival, barcode: @carpool.barcode, departure: @carpool.departure, notes: @carpool.notes, period: @carpool.period, sort_order: @carpool.sort_order, status: @carpool.status, transport_id: @carpool.transport_id, transport_name: @carpool.transport_name, type: @carpool.type }
    assert_redirected_to carpool_path(assigns(:carpool))
  end

  test "should destroy carpool" do
    assert_difference('Carpool.count', -1) do
      delete :destroy, id: @carpool
    end

    assert_redirected_to carpools_path
  end
end
