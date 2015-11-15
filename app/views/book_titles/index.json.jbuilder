json.array!(@book_titles) do |book_title|
  json.extract! book_title, :id, :title, :authors, :publisher
  json.url book_title_url(book_title, format: :json)
end
