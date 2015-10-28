class CourseText < ActiveRecord::Base
  belongs_to :course
  belongs_to :book_title

  accepts_nested_attributes_for :book_title, reject_if: :all_blank
end
