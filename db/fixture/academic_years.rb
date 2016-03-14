(2001..2020).each_with_index do |y|
  AcademicYear.seed(:id) do |s|
    s.id = y+1
    s.name = "#{y}-#{(y+1)}"
    s.start_date = Date.new(y, 6, 1)
    s.end_date = Date.new(y+1, 5, 31)]
  end
end
