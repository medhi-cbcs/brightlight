json.array!(@raw_units) do |raw_unit|
  json.extract! raw_unit, :id, :name, :notes
  json.url raw_unit_url(raw_unit, format: :json)
end
