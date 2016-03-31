namespace :data do
	desc "Import book price"
	task import_book_price: :environment do

    # xl = Roo::Spreadsheet.open('lib/tasks/Database_1.xlsx')
    # sheet = xl.sheet('CBCS_INVBOOKMASTERPRICE')

    header = {isbn:"BKISBN",notes:"BKNOTE",date_input:"BKDATEINPUT",time_input:"BKTIMEINPUT",book_index:"BKINDEX",user_id:"BKIDUSER",net_price:"BKNETTPRICE",
              shipping:"BKSHIPPINGPRICE",tax:"BKTAXPRICE",addl_price:"BKADDPRICE",price:"BKPRICE",currency:"BKPRICENAME",bkudid:"BKUDID",note_opr:"NOTEOPR"}

		client = TinyTds::Client.new username: 'dbest1', password: 'Sadrakh201', dataserver:'SERVER3000\CAHAYABANGSA05', database:'PROBEST1_0LD'
		results = client.execute("SELECT * FROM CBCS_INVBOOKMASTERPRICE")

    results.each_with_index do |row,i|
      edition = BookEdition.joins(:book_title).where(book_titles:{bkudid:row[header[:bkudid]]}).first
      edition.price = row[header[:price]]
      edition.currency = row[header[:currency]]
      edition.save
			puts "#{edition.title} - #{edition.currency} #{edition.price}"
    end
  end
end
