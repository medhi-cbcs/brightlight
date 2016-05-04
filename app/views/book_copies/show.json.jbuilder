json.book_copy do

  json.id @book_copy.id
  json.book_edition_id @book_copy.book_edition_id
  json.book_condition_id @book_copy.latest_condition.try(:id)
  json.book_condition @book_copy.latest_condition.try(:code)
  json.barcode @book_copy.barcode
  json.copy_no @book_copy.try(:book_label).try(:name)

  year = AcademicYear.current
  year_id = year.id
  json.academic_year do
    json.academic_year_id year_id
    json.start_date year.start_date
    json.end_date year.end_date
    json.prev_academic_year_id year_id-1
  end

  current_holder = @book_copy.book_loans.where(academic_year_id:year_id).take.try(:student)
  json.loans do
    json.student_name current_holder.try(:name)
  end

  json.book_edition do
    json.title @book_copy.book_edition.title
    json.isbn10 @book_copy.book_edition.isbn10
    json.isbn13 @book_copy.book_edition.isbn13
    json.authors @book_copy.book_edition.authors
    json.publisher @book_copy.book_edition.publisher
    json.price @book_copy.book_edition.price
    json.currency @book_copy.book_edition.currency
  end

  if @student.present?
    gss = @student.grade_sections_students.where(academic_year_id:year_id).take
    json.student do
      json.student_id @student.id
      json.student_name @student.name
      json.student_no @student.student_no
      json.roster_no gss.try(:order_no)
      json.grade_section_id gss.try(:grade_section_id)
      json.grade_level_id gss.try(:grade_section).try(:grade_level_id)
    end
  end
end
