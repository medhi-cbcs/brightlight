class AddColumnToGradeSectionsStudents < ActiveRecord::Migration
  def change
    add_column :grade_sections_students, :track, :string
  end
end
