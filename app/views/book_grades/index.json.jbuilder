json.array!(@book_grades) do |book_grade|
  json.extract! book_grade, :id, :book_id, :book_condition_id, :academic_year_id, :notes, :graded_by, :notes
  json.url book_grade_url(book_grade, format: :json)
end
