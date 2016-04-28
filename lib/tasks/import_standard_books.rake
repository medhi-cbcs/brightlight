namespace :data do
	desc "Import standard books"
	task import_standard_books: :environment do

    header = {isbn: 'BKISBN', date_input:'BKDATEINPUT', time_input: 'BKTIMEINPUT', index: 'BKINDEX', user_id: 'BKIDUSER',
              quantity: 'BKAMOUNT', grade_subject_code: 'BKIDGrade', grade_name: 'BKGradeName', academic_year: 'BKNewAcademicYear',
              class_level: 'BKClassLevelID', group: 'BKGroupID', category: 'BKCategory', refno: 'BKREFERENCE',
              bkudid: 'BKUDID', notes: 'NOTEOPR'}

    client = TinyTds::Client.new username: 'dbest1', password: 'Sadrakh201', dataserver:'SERVER3000\CAHAYABANGSA05', database:'PROBEST1_0LD'

    results = client.execute("SELECT * FROM [PROBEST1_0LD].[dbo].[CBCS_INVBOOKSTDTB]
                              UNION
                              SELECT * FROM [PROBEST1_0LD].[dbo].[CBCS_INVBOOKSTDTM]
                              UNION
                              SELECT * FROM [PROBEST1_0LD].[dbo].[CBCS_INVBOOKSTDSB]")

    results.each_with_index do |row, i|
      book_title = BookTitle.find_by_bkudid row[header[:bkudid]]
      if book_title.present?
        book_edition = book_title.book_editions.try(:first)
      else
        book_edition = BookEdition.find_by_legacy_code(row[header[:isbn]]) || BookEdition.find_by_refno(row[header[:refno]])
        book_title = book_edition.book_title
      end
      standard_book = StandardBook.new(
        book_title: book_title,
        book_edition: book_edition,
        grade_level: GradeLevel.find_by_code('CG'+row[header[:grade_subject_code]][2..4]),
        grade_section: GradeSection.find_by_subject_code(row[header[:grade_subject_code]]),
        academic_year: AcademicYear.find_by_name(row[header[:academic_year]]),
        book_category: BookCategory.find_by_code(row[header[:category]]),
        quantity: row[header[:quantity]],
        grade_subject_code: row[header[:grade_subject_code]],
        grade_name: row[header[:grade_name]],
        category: row[header[:category]],
        isbn: row[header[:isbn]],
        refno: row[header[:refno]],
        bkudid: row[header[:bkudid]],
        group: row[header[:group]],
        notes: row[header[:notes]] || "#{row[header[:academic_year]]}#{row[header[:notes]]}"
      )
      standard_book.save
      puts "#{i}. #{standard_book.book_title.try(:title) || 'Title N/A'} - #{row[header[:bkudid]]}"
    end
  end
end
