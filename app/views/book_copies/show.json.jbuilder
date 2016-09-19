json.book_copy do

  json.id @book_copy.id
  json.book_edition_id @book_copy.book_edition_id
  json.book_condition_id @book_copy.latest_condition.try(:id)
  json.book_condition @book_copy.latest_condition.try(:code)
  json.barcode @book_copy.barcode
  json.copy_no @book_copy.try(:book_label).try(:name)
  json.notes @book_copy.notes

  year_id = @year.id
  json.academic_year do
    json.academic_year_id year_id
    json.start_date @year.start_date
    json.end_date @year.end_date
    json.prev_academic_year_id year_id-1
  end

  if params[:anyyear] == 't'
    loan = @book_copy.book_loans.order('academic_year_id DESC','created_at DESC').take
  else
    loan = @book_copy.book_loans.where(academic_year_id:year_id).order('created_at DESC').take
  end

  if loan.present?
    json.loans do
      json.id             loan.try(:id)
      json.student_id     loan.try(:student_id)
      json.student_name   loan.try(:student).try(:name)
      json.employee_id    loan.try(:employee_id)
      json.employee_name  loan.try(:employee).try(:name)
      json.academic_year_id loan.try(:academic_year_id)
      json.return_status  loan.try(:return_status)
      json.return_date    loan.try(:return_date)
    end
  end

  if @book_edition.present?
    json.book_edition do
      json.id @book_edition.id
      json.title @book_edition.title
      json.isbn10 @book_edition.isbn10
      json.isbn13 @book_edition.isbn13
      json.authors @book_edition.authors
      json.publisher @book_edition.publisher
      json.price @book_edition.price
      json.currency @book_edition.currency
      json.small_thumbnail @book_edition.small_thumbnail
    end
  end

  if @book_title.present?
    json.book_title do
      json.id @book_title.id
      json.title @book_title.title
      json.bkudid @book_title.bkudid
      json.subject @book_title.subject
      json.subject_level @book_title.subject_level
      json.grade_code @book_title.grade_code
    end
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

  if @employee.present?
    json.employee do
      json.id @employee.id
      json.name @employee.name
      json.first_name @employee.first_name
      json.last_name @employee.last_name
      json.nick_name @employee.nick_name
      json.employee_number @employee.employee_number
    end
  end

end
