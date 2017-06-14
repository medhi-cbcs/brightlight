class AddlColumnsForBookFineMatters < ActiveRecord::Migration
  def change
    add_reference :book_fines, :grade_level, index: true, foreign_key: true
    add_reference :book_fines, :grade_section, index: true, foreign_key: true
    add_reference :book_fines, :student_book, index: true, foreign_key: true
    add_column :book_fines, :paid, :boolean

    add_reference :line_items, :book_fine, index: true, foreign_key: true

    add_reference :invoices, :academic_year, index: true, foreign_key: true
  end
end
