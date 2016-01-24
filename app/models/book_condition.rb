class BookCondition < ActiveRecord::Base
	validates :code, presence: true, uniqueness: true
	has_many :book_copies

end
