namespace :data do
	desc "Import book copiess"
	task import_book_copies: :environment do

    # Read Book title from INVBOOKMASTER
    xl = Roo::Spreadsheet.open('lib/tasks/Database_1.xlsx')
    sheet = xl.sheet('CBCS_INVWRITEBARCODE')

    header = {code_id:"WRLISTCODEID", barcode:"WRBARCODEID", isbn:"WRBKISBN",title_code:"WRTITLECODE",title_series:"WRTITLESERIES", title_volume:"WRTITLEVOLUME",
              user_id:"WRBKIDUSER", date_input:"WRDATEINPUT", time_input:"WRTIMEINPUT", wr_index:"WRINDEX",refno:"WRBKREFERENCE",notes:"WRNOTE",
              note_opr:"WRNOTEOPR", bkudid:"BKUDID"}

		ISBN10_REGEX = /^(?:\d[\ |-]?){9}[\d|X]$/i
		ISBN13_REGEX = /^(?:\d[\ |-]?){13}$/i

		sheet.each_with_index(header) do |copy,i|
			next if i < 1
			# break if i > 21
			barcode = copy[:barcode]

			title = BookTitle.find_by_bkudid(copy[:bkudid])
			if title.present?
				edition = title.book_editions.first
				book_copy = BookCopy.new(barcode: barcode, book_edition_id: edition.try(:id))
			else
				book_copy = BookCopy.new(barcode: barcode)
			end
			book_copy.save
			puts "#{i}. #{barcode} #{book_copy.book_edition.try(:title)}"
		end
  end
end
