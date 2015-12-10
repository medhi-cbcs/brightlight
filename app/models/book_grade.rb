class BookGrade < ActiveRecord::Base
  belongs_to :book
  belongs_to :book_condition
  belongs_to :academic_year
	#  belongs_to :person
end
