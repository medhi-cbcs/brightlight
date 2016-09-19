json.array!(@book_copies) do |book_copy|
  json.extract! book_copy, :id, :book_edition_id, :book_condition_id, :status_id, :barcode, :copy_no, :notes
  json.url book_copy_url(book_copy, format: :json)
end
