json.array!(@transports) do |transport|
  json.extract! transport, :id, :category, :name, :status, :active, :notes, :contact_id, :contact_name, :contact_phone, :contact_email
  json.url transport_url(transport, format: :json)
end
