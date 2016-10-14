json.array!(@students) do |student|
  if params[:term]
    json.id            student.id
    json.name          student.name
    json.grade_section student.grade_section_id
    json.grade         student.grade
    json.family_no     student.family_no
    json.roster_no     student.order_no    
  else
    json.student do
      json.id             student.id
      json.name           student.name
      json.grade_section  student.grade_section_id
      json.grade          student.grade
      json.family_no     student.family_no
      json.roster_no      student.order_no
    end
  end

end
