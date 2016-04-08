namespace :data do
	desc "Import book copiess"
	task import_book_copies: :environment do

    # Read Book title from INVBOOKMASTER
    # xl = Roo::Spreadsheet.open('lib/tasks/Database_1.xlsx')
    # sheet = xl.sheet('CBCS_INVWRITEBARCODE')

    header = {code_id:"WRLISTCODEID", barcode:"WRBARCODEID", isbn:"WRBKISBN",title_code:"WRTITLECODE",title_series:"WRTITLESERIES", title_volume:"WRTITLEVOLUME",
              user_id:"WRBKIDUSER", date_input:"WRDATEINPUT", time_input:"WRTIMEINPUT", wr_index:"WRINDEX",refno:"WRBKREFERENCE",notes:"WRNOTE",
              note_opr:"WRNOTEOPR", bkudid:"BKUDID"}

		client = TinyTds::Client.new username: 'dbest1', password: 'Sadrakh201', dataserver:'SERVER3000\CAHAYABANGSA05', database:'PROBEST1_0LD'
		results = client.execute("SELECT * FROM CBCS_INVWRITEBARCODE")

		results.each_with_index do |row, i|
			next if row[header[:wr_index]] != 1
			
			barcode = row[header[:barcode]]

			title = BookTitle.find_by_bkudid(row[header[:bkudid]])
			if title.present?
				edition = title.book_editions.first
				book_copy = BookCopy.new(barcode: barcode, book_edition_id: edition.try(:id))
			else
				book_copy = BookCopy.new(barcode: barcode)
			end
			book_copy.save
		  puts "#{i}. #{barcode} #{book_copy.book_edition.try(:title)}" if i % 100 == 0
		end
  end
end
