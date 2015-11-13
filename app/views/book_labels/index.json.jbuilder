json.array!(@book_labels) do |book_label|
  json.extract! book_label, :id, :grade_section_id, :student_id, :name
  json.url book_label_url(book_label, format: :json)
end
