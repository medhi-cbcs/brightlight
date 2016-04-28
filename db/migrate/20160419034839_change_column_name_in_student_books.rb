class ChangeColumnNameInStudentBooks < ActiveRecord::Migration
  def change
    rename_column :student_books, :needs_repair, :needs_rebinding
  end
end
