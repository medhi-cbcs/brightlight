json.array!(@food_lists) do |food_list|
  json.extract! food_list, :id, :name, :notes, :picture_url
  json.url food_list_url(food_list, format: :json)
end
