json.array!(@book_labels) do |book_label|
  json.id book_label.id
  json.value book_label.id
  json.grade_level_id book_label.grade_level_id
  json.grade_section_id book_label.grade_section_id
  json.label book_label.name
  json.book_no book_label.book_no
  json.url book_label_url(book_label, format: :json)
end
