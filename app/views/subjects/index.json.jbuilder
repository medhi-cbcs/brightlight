json.array!(@subjects) do |subject|
  json.extract! subject, :id, :code, :name, :description
  json.url subject_url(subject, format: :json)
end
