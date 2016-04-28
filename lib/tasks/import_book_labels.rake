namespace :data do
	desc "Import book labels"
	task import_book_labels: :environment do

  	header = {barcode: 'WRBARCODEID', class_level:'RENTClassLevelID',subject_id:'RENTSubjectID',roster_no:'RENTSTUDENTNUM'}
    subject_classes = ['CG011.1','CG011.2','CG012.1','CG012.2']

		client = TinyTds::Client.new username: 'dbest1', password: 'Sadrakh201', dataserver:'SERVER3000\CAHAYABANGSA05', database:'PROBEST1_0LD'

		['2015-2016', '2014-2015', '2013-2014', '2012-2013', '2011-2012'].each do |year|

      results = client.execute("SELECT WRBARCODEID,RENTClassLevelID,RENTSubjectID,RENTSTUDENTNUM
							  FROM [PROBEST1_0LD].[dbo].[CBCS_INVWRITEBARCODE]
							  LEFT JOIN [CBCS_INVBOOKSRENT]
								ON [WRBARCODEID] = [RENTBARCODEID] and [RENTCategory] = 'TB' and [RENTNewAcademicYear] = '#{year}'
							  WHERE [WRINDEX] = 1")

			results.each_with_index do |row, i|
				# no reason to update book_copy if there is no book_no
				# and skip if we can't find the grade level
				next if row[header[:roster_no]].blank? || row[header[:class_level]].blank?

				book_copy = BookCopy.find_by_barcode(row[header[:barcode]].upcase)

				next if book_copy.copy_no.present?  # skip if the book already has a label

				grade_section = if subject_classes.include?(row[header[:class_level]]) && row[header[:subject_id]].present?
                          GradeSection.find_by_subject_code(row[header[:subject_id]])
                        else
                          GradeSection.find_by_parallel_code(row[header[:class_level]])
                        end
				book_no = row[header[:roster_no]]
        book_label = BookLabel.where(grade_section:grade_section).where(book_no:book_no).take
				if book_label.present?
					book_copy.book_label = book_label
	        book_copy.copy_no = book_label.name
	        book_copy.save
	        puts "#{i}. #{row[header[:barcode]]}" if i % 500 == 0
				else
					puts "Couldn't find book label for #{row[header[:class_level]]}:#{row[header[:subject_id]]} ##{book_no}"
				end
      end
    end
  end
end
