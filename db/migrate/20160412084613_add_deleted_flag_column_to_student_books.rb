class AddDeletedFlagColumnToStudentBooks < ActiveRecord::Migration
  def change
    add_column :student_books, :deleted_flag, :boolean
    add_column :book_loans, :deleted_flag, :boolean
  end
end
