require 'test_helper'

class BookTitlesControllerTest < ActionController::TestCase
  setup do
    @book_title = book_titles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:book_titles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create book_title" do
    assert_difference('BookTitle.count') do
      post :create, book_title: {  }
    end

    assert_redirected_to book_title_path(assigns(:book_title))
  end

  test "should show book_title" do
    get :show, id: @book_title
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @book_title
    assert_response :success
  end

  test "should update book_title" do
    patch :update, id: @book_title, book_title: {  }
    assert_redirected_to book_title_path(assigns(:book_title))
  end

  test "should destroy book_title" do
    assert_difference('BookTitle.count', -1) do
      delete :destroy, id: @book_title
    end

    assert_redirected_to book_titles_path
  end
end
