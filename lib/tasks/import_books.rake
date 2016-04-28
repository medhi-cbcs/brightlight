require 'isbndb_client/api'

class InvalidISBN < StandardError
end

namespace :data do
	desc "Import books"
	task import_books: :environment do

    # Read Book title from INVBOOKMASTER
    xl = Roo::Spreadsheet.open('lib/tasks/Database_1.xlsx')
    book_master_sheet = xl.sheet('CBCS_INVBOOKMASTER')

    header = {bkudid:"BKUDID", isbn:"BKISBN", title:"BKTITLEMAIN", subject:"BKSUBJECT", year:"BKYEARPUBLISH", page_count:"BKNUMBERPAGE",
              notes:"BKNOTE", author:"BKAUTHOR", ed:"BKEDITION", publisher:"BKPUBLISHER", publisher_city:"BKTOWNPUBLISHER", location:"BKLOCATION",
              language:"BKLANGUAGE", cover_type:"BKCOVERTYPE", title_code:"BKTITLECODE", series:"BKTITLESERIES", volume:"BKTITLEVOLUME",
              date_input:"BKDATEINPUT", time_input:"BKTIMEINPUT", book_index:"BKINDEX", id_user:"BKIDUSER", refno:"BKREFERENCE",
              attachment_index:"BKATTACHINDEX", attachment_name:"BKATTACHNAME", attachment_qty:"BKATTACHAMOUNT", grade_id:"BKGRADEID", grade_level:"BKGRADELEVELID"}

    ISBN10_REGEX = /^(?:\d[\ |-]?){9}[\d|X]$/i
    ISBN13_REGEX = /^(?:\d[\ |-]?){13}$/i

  	#   books = []
    book_master_sheet.each_with_index(header) do |book,i|
      next if i < 965
    	# break if i > 20
      isbn = book[:isbn]
      puts isbn
      begin
        if !(isbn.match(ISBN13_REGEX) || isbn.match(ISBN10_REGEX))
					puts "Error: Invalid ISBN: #{isbn}"
					raise InvalidISBN
				end
        edition = BookEdition.searchGoogleAPI(isbn)
        if edition.blank?
					puts "Couldn't find #{isbn} in Google Books, trying ISBNDB.org"
          edition = BookEdition.searchISBNDB(isbn)
        end

        book_title = BookTitle.new(
          title: edition.title,
          authors: edition.authors,
          publisher: edition.publisher,
          image_url: edition.small_thumbnail,
          bkudid: book[:bkudid],
          subject: book[:subject]
          )
        book_title.book_editions.build edition.attributes
				book_title.save
				# books << book_title
			rescue GoogleBooks::API::Error => e
				puts "Breaking at no #{i}, ISBN: #{isbn}"
				puts e.message

				break
      rescue ISBNDBClient::API::Error, InvalidISBN
        book_title = BookTitle.new(
          title: book[:title],
          authors: book[:author],
          publisher: book[:publisher],
          bkudid: book[:bkudid],
          subject: book[:subject]
        )
        book_title.book_editions.build(
          isbn10: (isbn if isbn.match(ISBN10_REGEX)),
          isbn13: (isbn if isbn.match(ISBN13_REGEX)),
          title: book[:title],
          authors: book[:author],
          publisher: book[:publisher],
          published_date: Date.new(book[:year].to_i),
          page_count: book[:page_count].to_i,
          language: book[:language],
          refno: isbn || book[:refno],
          attachment_index: book[:attachment_index],
          attachment_name: book[:attachment_name],
          attachment_qty: book[:attachment_qty]
        )
				book_title.save
				# books << book_title
      end
    end

    # BookTitle.import books, recursive: true
    # Ooops, recursive only works on PostgreSQL

    # books.each { |book| book.save }

    # BookCategory.delete_all
    # columns = [:code, :name]
    # values = [['TB', 'Textbook'],['TM',"Teacher's Manual"],['SB','Story Book'],['PC','Packet'],['S','Sample']]
    # BookCategory.import columns, values

  end
end
