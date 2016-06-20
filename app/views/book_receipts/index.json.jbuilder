json.array!(@book_receipts) do |book_receipt|
  json.extract! book_receipt, :id, :book_copy_id, :academic_year_id, :student_id, :book_edition_id, :grade_section_id, :grade_level_id, :roster_no, :copy_no, :issue_date, :initial_condition_id, :return_condition_id, :barcode, :notes, :grade_section_code, :grade_subject_code, :course_id, :course_text_id, :active
  json.url book_receipt_url(book_receipt, format: :json)
end
