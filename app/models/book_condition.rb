class BookCondition < ActiveRecord::Base
	validates :code, presence: true, uniqueness: true
	has_many :book_copies

	COLORS = {"new"=>"blue", "good"=>"green", "fair"=>"orange", "poor"=>"red"}
end
