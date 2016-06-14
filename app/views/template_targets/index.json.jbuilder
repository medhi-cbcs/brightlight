json.array!(@template_targets) do |template_target|
  json.extract! template_target, :id, :name, :code, :description
  json.url template_target_url(template_target, format: :json)
end
