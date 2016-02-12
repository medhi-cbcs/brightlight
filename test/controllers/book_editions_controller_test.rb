require 'test_helper'

class BookEditionsControllerTest < ActionController::TestCase
  setup do
    @book_edition = book_editions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:book_editions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create book_edition" do
    assert_difference('BookEdition.count') do
      post :create, book_edition: { authors: @book_edition.authors, description: @book_edition.description, edition_info: @book_edition.edition_info, google_book_edition_id: @book_edition.google_book_edition_id, isbn10: @book_edition.isbn10, isbn13: @book_edition.isbn13, isbndb_id: @book_edition.isbndb_id, language: @book_edition.language, page_count: @book_edition.page_count, published_date: @book_edition.published_date, publisher: @book_edition.publisher, small_thumbnail: @book_edition.small_thumbnail, subjects: @book_edition.subjects, subtitle: @book_edition.subtitle, tags: @book_edition.tags, thumbnail: @book_edition.thumbnail, title: @book_edition.title }
    end

    assert_redirected_to book_edition_path(assigns(:book_edition))
  end

  test "should show book_edition" do
    get :show, id: @book_edition
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @book_edition
    assert_response :success
  end

  test "should update book_edition" do
    patch :update, id: @book_edition, book_edition: { authors: @book_edition.authors, description: @book_edition.description, edition_info: @book_edition.edition_info, google_book_edition_id: @book_edition.google_book_edition_id, isbn10: @book_edition.isbn10, isbn13: @book_edition.isbn13, isbndb_id: @book_edition.isbndb_id, language: @book_edition.language, page_count: @book_edition.page_count, published_date: @book_edition.published_date, publisher: @book_edition.publisher, small_thumbnail: @book_edition.small_thumbnail, subjects: @book_edition.subjects, subtitle: @book_edition.subtitle, tags: @book_edition.tags, thumbnail: @book_edition.thumbnail, title: @book_edition.title }
    assert_redirected_to book_edition_path(assigns(:book_edition))
  end

  test "should destroy book_edition" do
    assert_difference('BookEdition.count', -1) do
      delete :destroy, id: @book_edition
    end

    assert_redirected_to book_editions_path
  end
end
