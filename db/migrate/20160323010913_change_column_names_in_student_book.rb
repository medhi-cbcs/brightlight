class ChangeColumnNamesInStudentBook < ActiveRecord::Migration
  def change
    rename_column :student_books, :new_academic_year_id, :prev_academic_year_id
    rename_column :book_loans, :new_academic_year_id, :prev_academic_year_id
  end
end
