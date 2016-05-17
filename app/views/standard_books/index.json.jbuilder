json.array!(@standard_books) do |standard_book|
  json.id standard_book.book_title_id
  json.title standard_book.book_title.try(:title)
  json.book_edition_id standard_book.book_edition_id
  json.book_category_id standard_book.book_category_id
  json.isbn standard_book.isbn
  json.grade_level_id standard_book.grade_level_id
  json.grade_section_id standard_book.grade_section_id
  json.academic_year_id standard_book.academic_year_id
  json.url standard_book_url(standard_book, format: :json)
end
