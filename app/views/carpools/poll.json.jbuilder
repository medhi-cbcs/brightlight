json.carpool(@carpools) do |carpool|
  json.extract! carpool, :id, :category, :transport_id, :barcode, :transport_name, :period, :status, :arrival, :departure
end
json.reorder @reorder
json.timestamp @timestamp