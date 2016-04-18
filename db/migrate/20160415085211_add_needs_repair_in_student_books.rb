class AddNeedsRepairInStudentBooks < ActiveRecord::Migration
  def change
    add_column :student_books, :needs_repair, :boolean
  end
end
