require 'test_helper'

class BookLabelsControllerTest < ActionController::TestCase
  setup do
    @book_label = book_labels(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:book_labels)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create book_label" do
    assert_difference('BookLabel.count') do
      post :create, book_label: { grade_section_id: @book_label.grade_section_id, name: @book_label.name, student_id: @book_label.student_id }
    end

    assert_redirected_to book_label_path(assigns(:book_label))
  end

  test "should show book_label" do
    get :show, id: @book_label
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @book_label
    assert_response :success
  end

  test "should update book_label" do
    patch :update, id: @book_label, book_label: { grade_section_id: @book_label.grade_section_id, name: @book_label.name, student_id: @book_label.student_id }
    assert_redirected_to book_label_path(assigns(:book_label))
  end

  test "should destroy book_label" do
    assert_difference('BookLabel.count', -1) do
      delete :destroy, id: @book_label
    end

    assert_redirected_to book_labels_path
  end
end
