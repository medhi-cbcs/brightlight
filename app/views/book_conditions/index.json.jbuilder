json.array!(@book_conditions) do |book_condition|
  json.extract! book_condition, :id
  json.url book_condition_url(book_condition, format: :json)
end
