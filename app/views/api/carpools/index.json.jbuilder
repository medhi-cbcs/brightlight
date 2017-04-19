json.array!(@carpools) do |carpool|
  json.extract! carpool, :id, :transport_id, :transport_name, :barcode, :period, :sort_order, :active, :status, :category, :arrival, :departure
end
