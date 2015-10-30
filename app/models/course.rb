class Course < ActiveRecord::Base
  belongs_to :grade_level
  belongs_to :academic_year
  belongs_to :academic_term
  belongs_to :employee
  
  has_many :course_sections, dependent: :destroy
  accepts_nested_attributes_for :course_sections, allow_destroy: true, reject_if: :all_blank
  
  has_many :course_texts
  has_many :book_titles, through: :course_texts
  accepts_nested_attributes_for :course_texts, allow_destroy: true
end
