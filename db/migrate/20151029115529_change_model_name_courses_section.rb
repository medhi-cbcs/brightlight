class ChangeModelNameCoursesSection < ActiveRecord::Migration
  def change
  	rename_table :courses_sections, :course_sections
  end
end
