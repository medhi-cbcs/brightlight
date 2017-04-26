json.carpool do
  json.id @carpool.id
  json.category @carpool.category
  json.transport_name @carpool.transport_name
  json.transport_id @carpool.transport_id
  json.barcode @carpool.barcode
  json.sort_order @carpool.sort_order
  json.period @carpool.period
  json.status @carpool.status
  json.arrival @carpool.arrival
  json.departure @carpool.departure
  json.created_at @carpool.created_at
  json.updated_at @carpool.updated_at

  if params[:pax]
    json.passengers do
      json.array!(@carpool.passengers) do |passenger|
        json.id         passenger.id
        json.student_id passenger.student_id
        json.name       passenger.name
        json.grade      passenger.class_name
      end
    end
  end

  if params[:lpax]
    json.late_passengers do
      json.array!(@expected_passengers) do |passenger|
        json.id         passenger.id
        json.student_id passenger.student_id
        json.name       passenger.name
        json.grade      passenger.class_name
        json.active     passenger.active
      end
    end
  end
end
json.timestamp (@carpool.updated_at.to_f * 1000).to_i