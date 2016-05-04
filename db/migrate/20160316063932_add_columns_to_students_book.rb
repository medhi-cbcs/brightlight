class AddColumnsToStudentsBook < ActiveRecord::Migration
  def change
    add_column :student_books, :barcode, :string
    add_column :student_books, :student_no, :string
    add_column :student_books, :roster_no, :string
    add_column :student_books, :grade_section_code, :string
    add_column :student_books, :grade_subject_code, :string
    add_column :student_books, :notes, :string
    add_reference :student_books, :new_academic_year, index: true#, foreign_key: true
  end
end
