namespace :data do
	desc "Create missing copies"
	task create_missing_copies: :environment do
    BookLoan.where('book_copy_id is null').each do |loan|
      book_title = loan.book_title
      book_edition = book_title.book_editions.first
      unless BookCopy.where(barcode:loan.barcode).present?
        subject_classes = ['CG011.1','CG011.2','CG012.1','CG012.2']
        grade_section = if subject_classes.include?(loan.grade_section_code)
                          GradeSection.find_by_subject_code(loan.grade_subject_code)
                        else
                          GradeSection.find_by_parallel_code(loan.grade_section_code)
                        end
        book_label = BookLabel.where(grade_section:grade_section).where(book_no:loan.roster_no).take

        # Create the missing book copy
        book_copy = BookCopy.new(
                      barcode: loan.barcode,
                      book_edition_id: book_edition.id,
                      book_label: book_label,
                      copy_no: book_label.try(:name)
                    )
        book_copy.save
      else
        book_copy = BookCopy.where(barcode:loan.barcode).take
      end
      # Save the BookLoan record with the new book_copy_id
      loan.book_copy_id = book_copy.id
      loan.save

      # Now update missing data in CopyCondition and StudentBook records with the new book_copy.id
      CopyCondition.where('book_copy_id is null').where(barcode:loan.barcode).update_all(book_copy_id: book_copy.id)
      StudentBook.where('book_copy_id is null').where(barcode:loan.barcode).update_all(book_copy_id: book_copy.id)
    end

  end
end
