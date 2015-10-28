class BookEdition < ActiveRecord::Base
	validates_length_of :title, minimum: 2
	validates_uniqueness_of :isbn10, :allow_blank => true, :allow_nil => true
	validates_uniqueness_of :isbn13, :allow_blank => true, :allow_nil => true

	belongs_to :book_title

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

end
