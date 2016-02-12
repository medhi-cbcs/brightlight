# This is formatted so it will work with jQuery autocomplete
json.array!(@book_titles) do |book_title|
  json.id book_title.id
  json.label book_title.title
  json.value book_title.id
  json.image_url book_title.image_url
  json.url book_title_url(book_title, format: :json)
end
