json.array!(@school_years) do |school_year|
  json.extract! school_year, :id, :name, :start_date, :end_date
  json.url school_year_url(school_year, format: :json)
end
