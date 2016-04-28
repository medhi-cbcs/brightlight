json.array!(@fine_scales) do |fine_scale|
  json.extract! fine_scale, :id, :old_condition_id_id, :new_condition_id_id, :percentage
  json.url fine_scale_url(fine_scale, format: :json)
end
