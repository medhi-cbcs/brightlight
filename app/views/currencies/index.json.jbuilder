json.array!(@currencies) do |currency|
  json.extract! currency, :id, :foreign, :base, :rate, :user_id
  json.url currency_url(currency, format: :json)
end
