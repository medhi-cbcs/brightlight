json.array!(@carpools) do |carpool|
  json.extract! carpool, :id, :category, :transport_id, :barcode, :transport_name, :period, :sort_order, :active, :status, :arrival, :departure, :notes
  json.url carpool_url(carpool, format: :json)
  json.passengers do
    json.array!(carpool.passengers) do |passenger|
      json.id         passenger.id
      json.student_id passenger.student_id
      json.name       passenger.name
      json.class      passenger.class_name
    end
  end
end
