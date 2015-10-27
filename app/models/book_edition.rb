class BookEdition < ActiveRecord::Base
	validates_length_of :title, minimum: 2
	validates_uniqueness_of :isbn10, :allow_blank => true, :allow_nil => true
	validates_uniqueness_of :isbn13, :allow_blank => true, :allow_nil => true
	
	belongs_to :book_title
end
