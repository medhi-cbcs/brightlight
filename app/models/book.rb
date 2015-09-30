class Book < ActiveRecord::Base
	validates_length_of :title, minimum: 2
	validates_uniqueness_of :isbn10
	validates_uniqueness_of :isbn13
end
