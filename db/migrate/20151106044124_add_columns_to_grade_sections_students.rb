class AddColumnsToGradeSectionsStudents < ActiveRecord::Migration
  def change
    add_reference :grade_sections_students, :academic_year, index: true#, foreign_key: true
  end
end
