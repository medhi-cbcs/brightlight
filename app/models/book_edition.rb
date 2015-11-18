class BookEdition < ActiveRecord::Base
	validates :title, length: { minimum: 2 }
	validates :isbn10, uniqueness: true
	validates :isbn13, uniqueness: true
	validates :book_title, presence: true

	belongs_to :book_title
	has_many :book_copies
	accepts_nested_attributes_for :book_copies, allow_destroy: false
	
	def create_book_title
		book_title = BookTitle.create(
			title: self.title,
			publisher: self.publisher,
			authors: self.authors,
			image_url: self.small_thumbnail
		)
		self.book_title_id = book_title.id
		self.save
	end

	def create_book_copies(num=1)
		condition_ids = BookCondition.all.map {|bc| bc.id}
		status = Status.where(name:'On loan').first
		num.times do
			self.book_copies << BookCopy.new(
    		book_condition_id: condition_ids[rand(condition_ids.count)],
    		status_id: status.id,
    		barcode: rand(9876543210)
			)
		end
	end

end
