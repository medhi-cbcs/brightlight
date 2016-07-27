json.grade_section do
  json.id @grade_section.id
  json.name @grade_section.name
  json.grade_level_id @grade_section.grade_level_id
  json.number_of_students @grade_section.number_of_students_for_academic_year_id(@academic_year.id)
  json.academic_year @academic_year.name
  json.academic_year_id @academic_year.id
end
