json.array!(@book_fines) do |book_fine|
  json.extract! book_fine, :id, :book_copy_id, :old_condition_id, :new_condition_id, :fine, :academic_year_id, :student_id, :status
  json.url book_fine_url(book_fine, format: :json)
end
