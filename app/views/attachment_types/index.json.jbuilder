json.array!(@attachment_types) do |attachment_type|
  json.extract! attachment_type, :id, :code, :name
  json.url attachment_type_url(attachment_type, format: :json)
end
