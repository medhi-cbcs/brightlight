namespace :data do
	desc "Import book conditions"
	task import_book_conditions: :environment do

    # Read Book condition from CBCS_INVWRITECONDITIONS
    xl = Roo::Spreadsheet.open('lib/tasks/Database_1.xlsx')
    sheet = xl.sheet('CBCS_INVRETURNCONDITIONS')

    header = {barcode:"WRCONBARCODEID", isbn:"WRCONBKISBN", user_id:"WRCONBKIDUSER", date_input:"WRCONDATEINPUT", time_input:"WRCONTIMEINPUT",
              index:"WRCONINDEX", refno:"WRCONBKREFERENCE", condition_id:"WRCONCONDITIONID", new_acad_year:"WRCONNewAcademicYear", acad_year:"WRCONYearAcademic",
              bkudid:"BKUDID", notes:"NOTEOPR"}

    conditions = ['new','good','fair','poor','missing'].map {|condition| BookCondition.find_by_slug(condition)}
		year_ids = AcademicYear.all.reduce({}) {|hash,y| hash.merge({y.slug => y.id}) }

		columns = [:book_copy_id, :barcode, :book_condition_id, :start_date, :academic_year_id, :notes]
		values = []
		barcode = ''
		
		sheet.each_with_index(header) do |row,i|
			next if i < 1
			next if row[:index] == 0
			# break if i > 3
			barcode = row[:barcode]

			copy = BookCopy.find_by_barcode(barcode)
			if copy.present?
				data = [copy.id, barcode, conditions[row[:condition_id].to_i - 1], row[:date_input], year_ids[row[:new_acad_year]], row[:notes]]
			else
				data = [nil, barcode, conditions[row[:condition_id].to_i - 1], row[:date_input], year_ids[row[:new_acad_year]], barcode]
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
		puts "#{i}. #{barcode} Values # #{values.count}"

		# sheet.each_with_index(header) do |row,i|
		# 	next if i < 1
		#   # break if i > 21
		# 	barcode = row[:barcode]
		#
		# 	copy = BookCopy.find_by_barcode(barcode)
    #   unless row[:index] == 0
		# 		copy_condition = CopyCondition.new(
    #       book_copy: copy,
    #       barcode: barcode,
    #       book_condition: conditions[row[:condition_id].to_i - 1],
    #       start_date: row[:date_input],
    #       academic_year: year_ids[row[:new_acad_year]],
    #       notes: row[:notes]
    #     )
    #     copy_condition.save
		# 		puts "#{i}. #{barcode}" if i % 100 == 0
    #   end
		# end
  end
end
