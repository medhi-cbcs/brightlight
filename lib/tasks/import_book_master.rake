class InvalidISBN < StandardError
end

namespace :data do
	desc "Import book master"
	task import_book_master: :environment do

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

    books = []
    book_master_sheet.each_with_index(header) do |book,i|
      next if i < 1
      # break if i > 121
      isbn = book[:isbn]
      puts "#{i}. #{isbn}"

      book_title = BookTitle.new(
        title: book[:title].split.map {|s| !s.match(/\A[^AUIEO]+\z/) ? s.capitalize : s}.join(' '),
        authors: book[:author].split.map {|s| !s.match(/\A[^AUIEO]+\z/) ? s.capitalize : s}.join(' '),
        publisher: book[:publisher].split.map {|s| !s.match(/\A[^AUIEO]+\z/) ? s.capitalize : s}.join(' '),
        bkudid: book[:bkudid],
        subject: book[:subject]
      )
      book_title.book_editions.build(
        isbn10: (isbn if isbn.match(ISBN10_REGEX)),
        isbn13: (isbn if isbn.match(ISBN13_REGEX)),
        title: book_title.title,
        authors: book_title.authors,
        publisher: book_title.publisher,
        published_date: Date.new(book[:year].to_i),
        page_count: book[:page_count].to_i,
        language: book[:language].titleize,
        refno: isbn || book[:refno],
        attachment_index: book[:attachment_index],
        attachment_name: book[:attachment_name],
        attachment_qty: book[:attachment_qty]
      )

			book_title.save
    end

  end
end
