json.carpool do
  json.id @carpool.id
  json.category @carpool.category
  json.name @carpool.transport_name
  json.transport_id @carpool.transport_id
  json.barcode @carpool.barcode
  json.sort_order @carpool.sort_order
  json.period @carpool.period
  json.status @carpool.status
  json.arrival @carpool.arrival
  json.departure @carpool.departure
  json.created_at @carpool.created_at
  json.updated_at @carpool.updated_at

  json.passengers do
    json.array!(@carpool.passengers) do |passenger|
      json.student_id passenger.student_id
      json.name       passenger.name
      json.class      passenger.class_name
    end
  end
end
