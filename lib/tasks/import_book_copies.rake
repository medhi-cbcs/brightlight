namespace :data do
	desc "Import books"
	task import_books: :environment do

    # Read Book title from INVBOOKMASTER
    xl = Roo::Spreadsheet.open('lib/tasks/Database_1.xlsx')
    book_master_sheet = xl.sheet('CBCS_INVWRITEBARCODE')

    header = {code_id:"WRLISTCODEID", barcode:"WRBARCODEID", isbn:"WRBKISBN",title_code:"WRTITLECODE",title_series:"WRTITLESERIES", title_volume:"WRTITLEVOLUME",
              user_id:"WRBKIDUSER", date_input:"WRDATEINPUT", time_input:"WRTIMEINPUT", wr_index:"WRINDEX",refno:"WRBKREFERENCE",notes:"WRNOTE",
              note_opr:"WRNOTEOPR", bkudid:"BKUDID"}

    
  end
end
