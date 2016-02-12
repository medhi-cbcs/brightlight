json.array!(@book_labels) do |label|
  json.extract! label, :name, :id
end
