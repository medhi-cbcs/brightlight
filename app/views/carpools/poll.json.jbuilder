json.array!(@carpools) do |carpool|
  json.extract! carpool, :id, :category, :transport_id, :barcode, :transport_name, :period, :sort_order, :active, :status, :arrival, :departure, :notes
  if params[:pax]
    json.passengers do
      json.array!(carpool.passengers) do |passenger|
        json.id         passenger.id
        json.student_id passenger.student_id
        json.name       passenger.name
        json.grade      passenger.class_name
      end
    end
  end
  if params[:lpax]
    json.late_passengers do
      json.array!(carpool.late_passengers.active) do |passenger|
        json.id         passenger.id
        json.student_id passenger.student_id
        json.name       passenger.name
        json.grade      passenger.class_name
        json.status     passenger.active
      end
    end
  end
end
