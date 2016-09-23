json.array!(@raw_foods) do |raw_food|
  json.extract! raw_food, :id, :name, :brand, :kind, :min_stock, :raw_unit_id
  json.url raw_food_url(raw_food, format: :json)
end
