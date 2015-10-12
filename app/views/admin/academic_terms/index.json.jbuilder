json.array!(@academic_terms) do |academic_term|
  json.extract! academic_term, :id
  json.url academic_term_url(academic_term, format: :json)
end
