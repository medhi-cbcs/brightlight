json.array!(@grade_sections) do |section|
  json.extract! section, :name, :id
end
