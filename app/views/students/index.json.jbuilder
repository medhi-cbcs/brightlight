json.array!(@students) do |student|
  json.student do
    json.id student.id
    json.name student.name
    json.grade_section student.grade_section_id
    json.grade student.grade
    json.roster_no student.order_no
  end
end
