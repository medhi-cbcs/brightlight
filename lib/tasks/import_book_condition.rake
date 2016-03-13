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

		sheet.each_with_index(header) do |row,i|
			next if i < 1
		  # break if i > 21
			barcode = row[:barcode]

			copy = BookCopy.find_by_barcode(barcode)
      unless row[:index] == 0
				copy_condition = CopyCondition.new(
          book_copy: copy,
          barcode: barcode,
          book_condition: conditions[row[:condition_id].to_i - 1],
          start_date: row[:date_input],
          academic_year: AcademicYear.find_by_slug(row[:new_acad_year]),
          notes: row[:notes]
        )
        copy_condition.save
      end
		end
  end
end
