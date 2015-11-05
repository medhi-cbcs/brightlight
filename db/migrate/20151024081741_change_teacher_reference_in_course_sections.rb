class ChangeTeacherReferenceInCourseSections < ActiveRecord::Migration
  def change
  	remove_column :course_sections, :instructor
  	remove_column :course_sections, :employee_id
  	add_reference :course_sections, :instructor, index: true
  end
end
