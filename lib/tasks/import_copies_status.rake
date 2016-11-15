namespace :data do
	desc "Import copies status"
	task import_copies_status: :environment do

    # Read Book title from INVBOOKMASTER
    # xl = Roo::Spreadsheet.open('lib/tasks/Database_1.xlsx')
    # sheet = xl.sheet('CBCS_INVWRITEBARCODE')

    header = {code_id:"WRLISTCODEID", barcode:"WRBARCODEID", isbn:"WRBKISBN",title_code:"WRTITLECODE",title_series:"WRTITLESERIES", title_volume:"WRTITLEVOLUME",
              user_id:"WRBKIDUSER", date_input:"WRDATEINPUT", time_input:"WRTIMEINPUT", wr_index:"WRINDEX",refno:"WRBKREFERENCE",notes:"WRNOTE",
              note_opr:"WRNOTEOPR", bkudid:"BKUDID"}

		client = TinyTds::Client.new username: 'dbest1', password: 'Sadrakh201', dataserver:'SERVER3000\CAHAYABANGSA05', database:'PROBEST1_0LD'
		results = client.execute("SELECT * FROM CBCS_INVWRITEBARCODE WHERE WRINDEX != 1")

		results.each_with_index do |row, i|
			
			barcode = row[header[:barcode]]
      book_copy = BookCopy.find_by_barcode barcode
      book_copy.status = 6
			book_copy.save
		  puts "#{i}. #{barcode} #{book_copy.book_edition.try(:title)}" if i % 100 == 0
		end
  end
end
