namespace :data do
	desc "Add book loans to student books"
	task add_book_loans_to_student_books: :environment do
    student_books = StudentBook.joins('LEFT JOIN book_loans ON student_books.book_copy_id = book_loans.book_copy_id 
        AND student_books.academic_year_id = book_loans.academic_year_id
        AND student_books.student_id = book_loans.student_id')
      .where('student_books.student_id is not null')
      .select('book_loans.id bid, *')
    student_books.each do |s|
      # We don't want to trigger callbacks, so use update_column
      s.update_column :book_loan_id, s.bid
    end
  end
end 
