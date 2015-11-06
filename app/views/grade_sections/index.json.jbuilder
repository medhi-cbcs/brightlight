json.array!(@grade_sections) do |grade_section|
  json.extract! grade_section, :id
  json.url grade_section_url(grade_section, format: :json)
end
