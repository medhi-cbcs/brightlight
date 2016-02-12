json.array!(@departments) do |department|
  json.extract! department, :id, :name, :code, :manager
  json.url department_url(department, format: :json)
end
