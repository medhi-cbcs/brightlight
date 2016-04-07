class StandardBook < ActiveRecord::Base
  belongs_to :book_title
  belongs_to :book_edition
  belongs_to :book_category
  belongs_to :grade_level
  belongs_to :grade_section
  belongs_to :academic_year
end
