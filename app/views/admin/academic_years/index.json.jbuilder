json.array!(@academic_years) do |academic_year|
  json.extract! academic_year, :id, :name, :start_date, :end_date
  json.url academic_year_url(academic_year, format: :json)
end
