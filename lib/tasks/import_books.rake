require 'isbndb_client/api'

class InvalidISBN < StandardError
end

namespace :data do
	desc "Import books"
	task import_books: :environment do

    # Read Book title from INVBOOKMASTER
    xl = Roo::Spreadsheet.open('lib/tasks/Database_1.xlsx')
    sheet = xl.sheet('CBCS_INVBOOKMASTER')

    header = {bkudid:"BKUDID", isbn:"BKISBN", title:"BKTITLEMAIN", subject:"BKSUBJECT", year:"BKYEARPUBLISH", page_count:"BKNUMBERPAGE",
              notes:"BKNOTE", author:"BKAUTHOR", ed:"BKEDITION", publisher:"BKPUBLISHER", publisher_city:"BKTOWNPUBLISHER", location:"BKLOCATION",
              language:"BKLANGUAGE", cover_type:"BKCOVERTYPE", title_code:"BKTITLECODE", series:"BKTITLESERIES", volume:"BKTITLEVOLUME",
              date_input:"BKDATEINPUT", time_input:"BKTIMEINPUT", book_index:"BKINDEX", id_user:"BKIDUSER", refno:"BKREFERENCE",
              attachment_index:"BKATTACHINDEX", attachment_name:"BKATTACHNAME", attachment_qty:"BKATTACHAMOUNT", grade_id:"BKGRADEID", grade_level:"BKGRADELEVELID"}

    ISBN10_REGEX = /^(?:\d[\ |-]?){9}[\d|X]$/i
    ISBN13_REGEX = /^(?:\d[\ |-]?){13}$/i

    books = []
    sheet.each_with_index(header) do |book,i|
      next if i < 20
      break if i > 40
      isbn = book[:isbn]
      puts isbn
      begin
        raise InvalidISBN if !isbn.match(ISBN13_REGEX) || !isbn.match(ISBN10_REGEX)
        edition = BookEdition.searchGoogleAPI(isbn)
        count = 0
        if edition.blank? and count > 499
          edition = BookEdition.searchISBNDB(isbn)
          count += 1
        end

        book_title = BookTitle.new(
          title: edition.title,
          authors: edition.authors,
          publisher: edition.publisher,
          image_url: edition.small_thumbnail,
          bkuid: book[:bkuid],
          subject: book[:subject]
          )
        book_title.book_editions.build edition.attributes
        books << book_title

      rescue ISBNDBClient::API::Error, InvalidISBN
        book_title = BookTitle.new(
          title: book[:title],
          authors: book[:author],
          publisher: book[:publisher],
          bkuid: book[:bkuid],
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
        books << book_title
      end
    end

    BookTitle.import books, recursive: true

    # BookCategory.delete_all
    # columns = [:code, :name]
    # values = [['TB', 'Textbook'],['TM',"Teacher's Manual"],['SB','Story Book'],['PC','Packet'],['S','Sample']]
    # BookCategory.import columns, values


  end
end
