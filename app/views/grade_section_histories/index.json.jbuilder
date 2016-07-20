json.array!(@grade_section_histories) do |grade_section_history|
  json.extract! grade_section_history, :id, :index, :show
  json.url grade_section_history_url(grade_section_history, format: :json)
end
