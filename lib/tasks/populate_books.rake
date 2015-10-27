namespace :db do
	desc "Populate database with book titles and book editions"
	task populate_books: :environment do

		book_titles = ['inauthor:jane+austen','beowulf','saxon+math',
			'inauthor:susan+wise+bauer','inauthor:kelly+kapic','inauthor:wayne+grudem','inauthor:david+noebel',
			'inauthor:paul+foerster','inauthor:paul+hewitt','inauthor:Joseph+Gibaldi','inauthor:Chris+Krenzke',
			'inauthor:tolkien','inauthor:Walter+Scott','inauthor:Douglas+Wilson','inauthor:Erin+Fouberg',
			'inauthor:Peter+Kreeft','inauthor:Mitch+Stokes','niv+study+bible','esv+bible','The+Brothers+Menaechmus',
			'inauthor:john+saxon','Conceptual+Physics+The+High+School+Physics+Program','inauthor:Henslin+James',
			'MLA+Handbook+for+Writers+of+Research+Papers','inauthor:Patrick+Sebranek+dave+kemper',
			'inauthor:Sir+Walter+Scott','inauthor:Jacobs+Harold','Human+Geography+People+Place+and+Culture',
			'Focus+on+Grammar+3+An+Integrated+Skills+Approach','inauthor:c+s+lewis','inauthor:George+MacDonald',
			'Biblical+Worldview+Rhetoric','inauthor:Stedman+Ray','inauthor:Spielvogel+Jackson']	

		book_titles.each do |book_title|
			books = GoogleBooks::API.search(book_title,{count:30})
			books.each do |book|
				book_edition = BookEdition.new
				book_edition.title = book.title
	      book_edition.description = book.description
	      book_edition.authors = book.authors.join(', ')
	      book_edition.publisher = book.publisher
	      book_edition.isbn13 = book.isbn
	      book_edition.isbn10 = book.isbn_10
	      book_edition.page_count = book.page_count
	      book_edition.small_thumbnail = book.covers[:small]
	      book_edition.thumbnail = book.covers[:thumbnail]
	      book_edition.published_date = book.published_date 

	      book_edition.save
			end
		end
	end
end