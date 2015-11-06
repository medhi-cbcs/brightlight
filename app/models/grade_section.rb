class GradeSection < ActiveRecord::Base
  belongs_to :grade_level
  belongs_to :homeroom, class_name: "Employee"
  has_many :course_sections
  has_many :grade_sections_students
  has_many :students, through: :grade_sections_students

  accepts_nested_attributes_for :students
  accepts_nested_attributes_for :grade_sections_students, allow_destroy: true, reject_if: :all_blank
end
