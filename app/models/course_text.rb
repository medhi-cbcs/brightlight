class CourseText < ActiveRecord::Base
  belongs_to :course
  belongs_to :book_title
end
