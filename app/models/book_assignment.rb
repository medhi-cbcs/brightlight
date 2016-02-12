class BookAssignment < ActiveRecord::Base
  belongs_to :book
  belongs_to :student
  belongs_to :academic_year
  belongs_to :course_text
  belongs_to :status
end
