class ChangeTeacherReferenceInGradeSections < ActiveRecord::Migration
  def change
  	remove_column :grade_sections, :homeroom
  	add_reference :grade_sections, :homeroom, index: true
  end
end
