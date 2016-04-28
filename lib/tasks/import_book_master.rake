class InvalidISBN < StandardError
end

namespace :data do
	desc "Import book master"
	task import_book_master: :environment do

		use_sql_server = true


    header = {bkudid:"BKUDID", isbn:"BKISBN", title:"BKTITLEMAIN", subject:"BKSUBJECT", year:"BKYEARPUBLISH", page_count:"BKNUMBERPAGE",
              notes:"BKNOTE", author:"BKAUTHOR", ed:"BKEDITION", publisher:"BKPUBLISHER", publisher_city:"BKTOWNPUBLISHER", location:"BKLOCATION",
              language:"BKLANGUAGE", cover_type:"BKCOVERTYPE", title_code:"BKTITLECODE", series:"BKTITLESERIES", volume:"BKTITLEVOLUME",
              date_input:"BKDATEINPUT", time_input:"BKTIMEINPUT", book_index:"BKINDEX", id_user:"BKIDUSER", refno:"BKREFERENCE",
              attachment_index:"BKATTACHINDEX", attachment_name:"BKATTACHNAME", attachment_qty:"BKATTACHAMOUNT", grade_id:"BKGRADEID", grade_level:"BKGRADELEVELID"}

    ISBN10_REGEX = /^(?:\d[\ |-]?){9}[\d|X]$/i
    ISBN13_REGEX = /^(?:\d[\ |-]?){13}$/i

		if use_sql_server
			client = TinyTds::Client.new username: 'dbest1', password: 'Sadrakh201', dataserver:'SERVER3000\CAHAYABANGSA05', database:'PROBEST1_0LD'
			results = client.execute("SELECT * FROM CBCS_INVBOOKMASTER")

			results.each_with_index do |row, i|
	      isbn = row[header[:isbn]]
	      puts "#{i}. #{isbn}"

	      book_title = BookTitle.new(
	        title: row[header[:title]].split.map {|s| !s.match(/\A[^AUIEO]+\z/) ? s.capitalize : s}.join(' '),
	        authors: row[header[:author]].split.map {|s| !s.match(/\A[^AUIEO]+\z/) ? s.capitalize : s}.join(' '),
	        bkudid: row[header[:bkudid]],
	        subject: row[header[:subject]],
					subject_level: row[header[:grade_id]],
					grade_code: row[header[:grade_level]]
	      )

	      book_title.book_editions.build(
	        isbn10: (isbn if isbn.match(ISBN10_REGEX)),
	        isbn13: (isbn if isbn.match(ISBN13_REGEX)),
	        title: book_title.title,
	        authors: book_title.authors,
	        publisher: row[header[:publisher]].split.map {|s| !s.match(/\A[^AUIEO]+\z/) ? s.capitalize : s}.join(' '),
	        published_date: Date.new(row[header[:year]].to_i),
	        page_count: row[header[:page_count]].to_i,
	        language: row[header[:language]].titleize,
	        refno: row[header[:refno]],
					legacy_code: row[header[:isbn]],
	        attachment_index: row[header[:attachment_index]],
	        attachment_name: row[header[:attachment_name]],
	        attachment_qty: row[header[:attachment_qty]]
	      )

				book_title.book_editions.each &:reset_slug
				book_title.save(validate: false)
			end

		else
	    # Read Book title from INVBOOKMASTER
	    xl = Roo::Spreadsheet.open('lib/tasks/Database_1.xlsx')
	    book_master_sheet = xl.sheet('CBCS_INVBOOKMASTER')

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
end
