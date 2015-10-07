json.array!(@book_assignments) do |book_assignment|
  json.extract! book_assignment, :id, :book_id, :student_id, :academic_year_id, :course_text_id, :issue_date, :return_date, :initial_condition_id, :end_condition_id, :status_id
  json.url book_assignment_url(book_assignment, format: :json)
end
