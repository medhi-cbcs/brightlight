class AddColumnToBookLabel < ActiveRecord::Migration
  def change
    add_reference :book_labels, :grade_section, index: true, foreign_key: true
  end
end
