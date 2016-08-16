json.array!(@carpools) do |carpool|
  json.extract! carpool, :id, :type, :transport_id, :barcode, :transport_name, :period, :sort_order, :active, :status, :arrival, :departure, :notes
  json.url carpool_url(carpool, format: :json)
end
