namespace :data do
	desc "Import book conditions"
	task import_book_conditions: :environment do

		use_sql_server = true


    header = {barcode:"WRCONBARCODEID", isbn:"WRCONBKISBN", user_id:"WRCONBKIDUSER", date_input:"WRCONDATEINPUT", time_input:"WRCONTIMEINPUT",
              index:"WRCONINDEX", refno:"WRCONBKREFERENCE", condition_id:"WRCONCONDITIONID", new_acad_year:"WRCONNewAcademicYear", acad_year:"WRCONYearAcademic",
              bkudid:"BKUDID", notes:"NOTEOPR"}

    conditions = ['new','good','fair','poor','missing'].map {|condition| BookCondition.find_by_slug(condition)}
		year_ids = AcademicYear.all.reduce({}) {|hash,y| hash.merge({y.slug => y.id}) }

		columns = [:book_copy_id, :barcode, :book_condition_id, :start_date, :academic_year_id, :notes, :post, :deleted_flag]

		client = TinyTds::Client.new username: 'dbest1', password: 'Sadrakh201', dataserver:'SERVER3000\CAHAYABANGSA05', database:'PROBEST1_0LD'
		['CBCS_INVWRITECONDITIONS','CBCS_INVRETURNCONDITIONS'].each_with_index do |table,post|
			values = []
			barcode = ''
			puts "Reading from #{table}"
			results = client.execute("SELECT * FROM #{table}")

			results.each_with_index do |row, i|
				barcode = row[header[:barcode]].upcase

				copy = BookCopy.find_by_barcode(barcode)
				deleted_flag = row[header[:index]] == 0
				# puts "#{row[header[:barcode]]}:#{row[header[:condition_id]]}:#{row[header[:new_acad_year]]} | #{copy.try(:book_edition).try(:title)}"

				if copy.present?
					data = [copy.id, barcode, conditions[row[header[:condition_id]].to_i - 1].id, row[header[:date_input]], year_ids[row[header[:new_acad_year]]], row[header[:notes]], post, deleted_flag]
				else
					data = [nil, barcode, conditions[row[header[:condition_id]].to_i - 1].id, row[header[:date_input]], year_ids[row[header[:new_acad_year]]], barcode, post, deleted_flag]
				end
				values << data

				# insert to DB every 100 rows
				if i % 100 == 0
					puts "#{i}. #{barcode} Values # #{values.count}"
					CopyCondition.import columns, values, validates: false
					values = []
				end
			end

			# insert the remaining rows, if any
			if values.count > 0
				CopyCondition.import columns, values, validates: false
			end
			puts "#{barcode} Values # #{values.count}"
			results.cancel
		end

  end
end
