class AddBookEditionColumnToStudentBooks < ActiveRecord::Migration
  def change
    add_reference :student_books, :book_edition, index: true, foreign_key: true
  end
end
