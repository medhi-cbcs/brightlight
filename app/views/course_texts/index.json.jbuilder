json.array!(@course_texts) do |course_text|
  json.extract! course_text, :id
  json.url course_text_url(course_text, format: :json)
end
