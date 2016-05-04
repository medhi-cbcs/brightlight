class AddColumnsToBookLoan < ActiveRecord::Migration
  def change
    add_column :book_loans, :student_no, :string
    add_column :book_loans, :roster_no, :string
    add_column :book_loans, :barcode, :string
    add_column :book_loans, :refno, :string
    add_column :book_loans, :grade_section_code, :string
    add_column :book_loans, :grade_subject_code, :string
    add_column :book_loans, :notes, :string
    add_reference :book_loans, :new_academic_year, index: true#, foreign_key: true
    add_column :book_loans, :loan_status, :string
    add_column :book_loans, :return_status, :string
    add_column :book_loans, :bkudid, :string
    add_column :book_loans, :return_date, :date
    add_reference :book_loans, :employee, index: true#, foreign_key: true
    add_column :book_loans, :employee_no, :string
    add_reference :book_loans, :student, index: true#, foreign_key: true
  end
end
