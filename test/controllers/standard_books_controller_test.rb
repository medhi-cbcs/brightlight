require 'test_helper'

class StandardBooksControllerTest < ActionController::TestCase
  setup do
    @standard_book = standard_books(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:standard_books)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create standard_book" do
    assert_difference('StandardBook.count') do
      post :create, standard_book: { academic_year_id: @standard_book.academic_year_id, bkudid: @standard_book.bkudid, book_category_id: @standard_book.book_category_id, book_edition_id: @standard_book.book_edition_id, book_title_id: @standard_book.book_title_id, category: @standard_book.category, grade_level_id: @standard_book.grade_level_id, grade_name: @standard_book.grade_name, grade_section_id: @standard_book.grade_section_id, grade_subject_code: @standard_book.grade_subject_code, group: @standard_book.group, isbn: @standard_book.isbn, notes: @standard_book.notes, quantity: @standard_book.quantity, refno: @standard_book.refno }
    end

    assert_redirected_to standard_book_path(assigns(:standard_book))
  end

  test "should show standard_book" do
    get :show, id: @standard_book
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @standard_book
    assert_response :success
  end

  test "should update standard_book" do
    patch :update, id: @standard_book, standard_book: { academic_year_id: @standard_book.academic_year_id, bkudid: @standard_book.bkudid, book_category_id: @standard_book.book_category_id, book_edition_id: @standard_book.book_edition_id, book_title_id: @standard_book.book_title_id, category: @standard_book.category, grade_level_id: @standard_book.grade_level_id, grade_name: @standard_book.grade_name, grade_section_id: @standard_book.grade_section_id, grade_subject_code: @standard_book.grade_subject_code, group: @standard_book.group, isbn: @standard_book.isbn, notes: @standard_book.notes, quantity: @standard_book.quantity, refno: @standard_book.refno }
    assert_redirected_to standard_book_path(assigns(:standard_book))
  end

  test "should destroy standard_book" do
    assert_difference('StandardBook.count', -1) do
      delete :destroy, id: @standard_book
    end

    assert_redirected_to standard_books_path
  end
end
