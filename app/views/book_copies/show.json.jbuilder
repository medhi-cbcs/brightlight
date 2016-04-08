json.book_copy do
  json.id @book_copy.id
  json.book_edition_id @book_copy.book_edition_id
  json.book_condition_id @book_copy.book_condition_id
  json.book_condition @book_copy.latest_condition.try(:code)
  json.barcode @book_copy.barcode
  json.copy_no @book_copy.copy_no

  json.book_edition do
    json.title @book_copy.book_edition.title
    json.isbn10 @book_copy.book_edition.isbn10
    json.isbn13 @book_copy.book_edition.isbn13
    json.authors @book_copy.book_edition.authors
    json.publisher @book_copy.book_edition.publisher
  end
end
