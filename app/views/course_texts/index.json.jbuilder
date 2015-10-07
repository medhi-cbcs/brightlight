json.array!(@course_texts) do |course_text|
  json.extract! course_text, :id, :title, :author, :publisher, :image_url, :notes, :course_id
  json.url course_text_url(course_text, format: :json)
end
