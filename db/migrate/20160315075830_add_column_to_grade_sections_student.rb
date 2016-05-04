class AddColumnToGradeSectionsStudent < ActiveRecord::Migration
  def change
    add_reference :grade_sections_students, :grade_section_history, index: true#, foreign_key: true
    add_column :grade_sections_students, :notes, :string
  end
end
