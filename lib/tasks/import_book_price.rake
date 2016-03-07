namespace :data do
	desc "Import book price"
	task import_book_price: :environment do

    # Read Book title from INVBOOKMASTER
    xl = Roo::Spreadsheet.open('lib/tasks/Database_1.xlsx')
    sheet = xl.sheet('CBCS_INVBOOKMASTERPRICE')

    header = {isbn:"BKISBN",notes:"BKNOTE",date_input:"BKDATEINPUT",time_input:"BKTIMEINPUT",book_index:"BKINDEX",user_id:"BKIDUSER",net_price:"BKNETTPRICE",
              shipping:"BKSHIPPINGPRICE",tax:"BKTAXPRICE",addl_price:"BKADDPRICE",price:"BKPRICE",currency:"BKPRICENAME",bkudid:"BKUDID",note_opr:"NOTEOPR"}

    sheet.each_with_index(header) do |book,i|
      next if i < 1
      edition = BookEdition.where(isbn:book[:isbn]).first
      edition.price = book[:price]
      edition.currency = book[:currency]
      edition.save
    end
  end
end
