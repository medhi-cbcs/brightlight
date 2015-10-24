class ChangeTeacherReferenceInCourseSections < ActiveRecord::Migration
  def change
  	remove_column :courses_sections, :instructor
  	remove_column :courses_sections, :employee_id
  	add_reference :courses_sections, :instructor, index: true
  end
end
