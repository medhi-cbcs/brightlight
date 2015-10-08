require 'test_helper'

class CourseTextsControllerTest < ActionController::TestCase
  setup do
    @course_text = course_texts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:course_texts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create course_text" do
    assert_difference('CourseText.count') do
      post :create, course_text: { author: @course_text.author, course_id: @course_text.course_id, image_url: @course_text.image_url, notes: @course_text.notes, publisher: @course_text.publisher, title: @course_text.title }
    end

    assert_redirected_to course_text_path(assigns(:course_text))
  end

  test "should show course_text" do
    get :show, id: @course_text
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @course_text
    assert_response :success
  end

  test "should update course_text" do
    patch :update, id: @course_text, course_text: { author: @course_text.author, course_id: @course_text.course_id, image_url: @course_text.image_url, notes: @course_text.notes, publisher: @course_text.publisher, title: @course_text.title }
    assert_redirected_to course_text_path(assigns(:course_text))
  end

  test "should destroy course_text" do
    assert_difference('CourseText.count', -1) do
      delete :destroy, id: @course_text
    end

    assert_redirected_to course_texts_path
  end
end
