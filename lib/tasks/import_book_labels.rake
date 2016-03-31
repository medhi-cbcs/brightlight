namespace :data do
	desc "Import book labels"
	task import_book_labels: :environment do

		use_sql_server = true

  	header = {class_level:'RENTClassLevelID', level_name:'ParalelLevelName', roster_no:'RENTSTUDENTNUM',
              subject_id:'RENTSubjectID', barcode: 'RENTBARCODEID', new_academic_year: 'RENTNewAcademicYear'}
    subject_classes = ['CG011.1','CG011.2','CG012.1','CG012.2']

		if use_sql_server
			client = TinyTds::Client.new username: 'dbest1', password: 'Sadrakh201', dataserver:'SERVER3000\CAHAYABANGSA05', database:'PROBEST1_0LD'

      # labels = client.execute("SELECT [RENTClassLevelID],[ParalelLevelName],[RENTSTUDENTNUM],[RENTSubjectID]
      #             FROM [PROBEST1_0LD].[dbo].[CBCS_INVBOOKSRENT]
      #           INNER JOIN [CBCS_Paralel_Class] on [RENTClassLevelID] = [ParalelLevelID]
      #           WHERE [RENTNewAcademicYear] = '2015-2016'
      #           GROUP BY [RENTClassLevelID],[ParalelLevelName],[RENTSubjectID],[RENTSTUDENTNUM]")
      #
      # labels.each_with_index do |row, i|
			# 	grade_section = if subject_classes.include? row[header[:class_level]]
      #                     GradeSection.find_by_subject_code(row[header[:subject_id]])
      #                   else
      #                     GradeSection.find_by_parallel_code(row[header[:class_level]])
      #                   end
      #   grade_level = grade_section.grade_level
      #   order_no = row[header[:roster_no]]
      #   name = if grade_section.grade_level_id > 12
      #            "#{grade_section.name}##{order_no}"
      #          else
      #            "#{grade_section.name.match(/Grade (.+)/)[1]}##{order_no}"
      #          end
      #   label = BookLabel.create(grade_level:grade_level, grade_section:grade_section,
      #               name:name, book_no:order_no)
      #   label.save
      # end
      # labels.cancel

      results = client.execute("SELECT [RENTClassLevelID],[ParalelLevelName],[RENTSTUDENTNUM],[RENTSubjectID],
                       [RENTBARCODEID],[RENTNewAcademicYear]
                  FROM [PROBEST1_0LD].[dbo].[CBCS_INVBOOKSRENT]
                INNER JOIN [CBCS_Paralel_Class] on [RENTClassLevelID] = [ParalelLevelID]
                WHERE [RENTNewAcademicYear] = '2015-2016'
                ORDER BY [RENTClassLevelID],[RENTSubjectID],[RENTSTUDENTNUM]")

			results.each_with_index do |row, i|
				book_copy = BookCopy.find_by_barcode(row[header[:barcode]].upcase)
				grade_section = if subject_classes.include? row[header[:class_level]]
                          GradeSection.find_by_subject_code(row[header[:subject_id]])
                        else
                          GradeSection.find_by_parallel_code(row[header[:class_level]])
                        end
        order_no = row[header[:roster_no]]
        book_label = BookLabel.where(grade_section:grade_section).where(book_no:order_no).first
        book_copy.book_label = book_label
        book_copy.copy_no = book_label.name
        #book_copy.save
        #if i % 500 == 0
          puts "#{i}. #{row[header[:barcode]]}"
        #end
      end
    end
  end
end
