class AddColumnToBookAssignment < ActiveRecord::Migration
  def change
    add_reference :book_assignments, :grade_section, index: true, foreign_key: true
  end
end
