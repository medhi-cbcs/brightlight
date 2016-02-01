json.array!(@student_books) do |student_book|
  json.extract! student_book, :id, :student_id, :book_copy_id, :academic_year_id, :course_text_id, :copy_no, :grade_section_id, :grade_level_id, :course_text_id, :course_id, :issue_date, :return_date, :initial_copy_condition_id, :end_copy_condition_id
  json.url student_book_url(student_book, format: :json)
end
