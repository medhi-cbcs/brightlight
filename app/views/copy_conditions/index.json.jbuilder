json.array!(@copy_conditions) do |copy_condition|
  json.extract! copy_condition, :id, :book_copy_id, :book_condition_id, :academic_year_id, :barcode, :notes, :user_id, :start_date, :end_date
  json.url copy_condition_url(copy_condition, format: :json)
end
