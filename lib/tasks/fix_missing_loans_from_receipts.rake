namespace :data do
	desc "Fix mission loans records when importing from receipts"
	task fix_missing_loans_from_receipts: :environment do
    
        academic_year = AcademicYear.where(name:'2016-2017').take

        GradeLevel.all.each do |gl|
            puts "Grade #{gl.name}"
            missing_records = BookReceipt
                .joins("JOIN grade_sections_students gss ON gss.order_no = book_receipts.roster_no
                    AND gss.academic_year_id = book_receipts.academic_year_id
                    AND gss.grade_section_id = book_receipts.grade_section_id")
                .where(academic_year: academic_year, grade_level: gl)
                .where("book_copy_id NOT IN (SELECT book_copy_id FROM book_loans
                        WHERE academic_year_id = #{academic_year.id}
                        AND grade_level_id = #{gl.id})")
            missing_records.each_with_index do |receipt, i|                           
                student = receipt.student
                puts "   #{i+1}. #{student.name} ##{receipt.roster_no}: #{receipt.barcode}"
                StudentBook.create(
                    receipt.attributes
                    .except('id', 'created_at', 'updated_at', 'notes', 'roster_no', 'active', 'initial_condition_id',       
                            'return_condition_id')
                    .merge('roster_no' => receipt.roster_no.to_s, 'student_id' => student.id, 'issue_date' => receipt.created_at,
                            'deleted_flag' => false, 'student_no' => student.student_no,
                            'initial_copy_condition_id' => receipt.initial_condition_id)
                ) do |sb|
                    book_title_id = sb.book_edition.try(:book_title_id)
                    book_title = BookTitle.find book_title_id
                    standard_book = StandardBook.where(book_title_id: book_title_id, academic_year_id:sb.academic_year_id).take
                    book_category = standard_book.try(:book_category_id)

                    # Create BookLoan record if it's missing also
                    if BookLoan.where(book_copy_id: receipt.book_copy_id, academic_year_id: receipt.academic_year_id).blank?
                        BookLoan.create({
                            academic_year_id: sb.academic_year_id,
                            barcode:          sb.barcode,
                            book_edition_id:  sb.book_edition_id,
                            book_title_id:    book_title_id,
                            book_category_id: book_category,
                            bkudid:           book_title.try(:bkudid),
                            book_copy_id:     sb.book_copy_id,
                            out_date:         sb.issue_date,
                            loan_status:      'B',
                            refno:            sb.book_edition.try(:refno),
                            roster_no:        sb.roster_no,
                            student_id:       sb.student_id,
                            student_no:       sb.student_no,
                            deleted_flag:     false
                        })
                    end
                end
            end
        end
    end

end