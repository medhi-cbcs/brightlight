namespace :data do
	desc "Import class capacity"
	task import_class_capacity: :environment do

  	header = {grade_id: 'CapacityIDGrade', capacity: 'CapacityNumber', academic_year: 'CapacityYearAcademic',
              class_level: 'CapacityLevelID', subject_id: 'CapacitySUBJECTLevelID', index: 'CapacityIndex',
              date_input: 'CapacityDateInput', time_input: 'CapacityTimeInput', user_id: 'CapacityIDUser', notes: 'CapacityNote'}
    subject_classes = ['CG011.1','CG011.2','CG012.1','CG012.2']

		client = TinyTds::Client.new username: 'dbest1', password: 'Sadrakh201', dataserver:'SERVER3000\CAHAYABANGSA05', database:'PROBEST1_0LD'
    results = client.execute("SELECT * FROM CBCS_CLASS_CAPACITY")

    results.each_with_index do |row, i|
      grade_section = if subject_classes.include?(row[header[:class_level]]) && row[header[:subject_id]].present?
                        GradeSection.find_by_subject_code(row[header[:subject_id]])
                      else
                        GradeSection.find_by_parallel_code(row[header[:class_level]])
                      end
      if grade_section.present?
        if row[header[:academic_year]] == '2015-2016'
          grade_section.capacity = row[header[:capacity]]
          grade_section.save(validate: false)
          puts "#{i}. [#{row[header[:class_level]]}:#{row[header[:subject_id]]}] #{grade_section.name} (#{row[header[:academic_year]]}): #{grade_section.capacity}"
        else
          year = AcademicYear.find_by_name row[header[:academic_year]]
          grade_section_history = grade_section.grade_section_histories.where(academic_year:year).take
          grade_section_history.capacity = row[header[:capacity]]
          grade_section_history.save(validate: false)
          puts "#{i}. [#{row[header[:class_level]]}:#{row[header[:subject_id]]}] #{grade_section_history.name} (#{row[header[:academic_year]]}): #{grade_section_history.capacity}"
        end
      end
    end
  end
end
