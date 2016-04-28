
cc = GradeSection.with_academic_year(6).where(grade_level:1).joins(:students).group("grade_sections.name").count

s1a = GradeSection.first
m1a = s1a.course_sections.first
bt1 = m1a.course.book_titles.first

labels = cc.to_a.map {|s,n| Array(1..n).map {|c| "#{s}##{c}"}}.flatten.reverse

m1a.course.book_titles.each {|t| labels = cc.to_a.map {|s,n| Array(1..n).map {|c| "#{s}##{c}"}}.flatten.reverse; t.book_editions.first.book_copies.each {|b| puts b.barcode+' '+(labels.pop||'Copy') } }
