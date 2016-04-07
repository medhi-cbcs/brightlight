json.array!(@standard_books) do |standard_book|
  json.extract! standard_book, :id, :book_title_id, :book_edition_id, :book_category_id, :isbn, :refno, :quantity, :grade_subject_code, :grade_name, :grade_level_id, :grade_section_id, :group, :category, :bkudid, :notes, :academic_year_id
  json.url standard_book_url(standard_book, format: :json)
end
