class AddBookLoanIdToStudentBook < ActiveRecord::Migration
  def change
    add_column :student_books, :book_loan_id, :integer
    add_index :student_books, :book_loan_id
  end
end
