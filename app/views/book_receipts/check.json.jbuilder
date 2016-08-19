json.book_copy do
  json.id @book_copy.id
  json.title @book_copy.book_edition.try(:title)
  json.book_edition_id @book_copy.book_edition_id
  json.book_condition_id @book_copy.latest_condition.try(:id)
  json.book_condition @book_copy.latest_condition.try(:code)
  json.barcode @book_copy.barcode
  json.copy_no @book_copy.try(:book_label).try(:name)
end
