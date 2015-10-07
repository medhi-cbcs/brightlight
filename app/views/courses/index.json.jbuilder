json.array!(@courses) do |course|
  json.extract! course, :id, :name, :number, :description, :grade_level_id, :academic_year_id, :academic_term_id, :employee_id
  json.url course_url(course, format: :json)
end
