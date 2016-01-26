namespace :db do
	desc "Populate database with book copies"
	task populate_book_copies: :environment do
		
		BookCopy.delete_all
		CopyCondition.delete_all

		condition_ids = BookCondition.all.map {|bc| bc.id}
    new_condition_id = BookCondition.where(code:'new').first.id
    status = Status.where(name:'On loan').first

		academic_year_id = AcademicYear.current_id
		user = User.first

		n = 0
		CourseText.find_each do |textbook|
			
			next if textbook.course.blank?
			next if textbook.book_title.blank?

			n += 1
			puts "#{n}. Course: #{textbook.course.name} - Book: #{textbook.book_title.title}"

			textbook.book_title.book_editions.find_each do |edition|
		    textbook.course.course_sections.each do |cs|
		    	puts "Section #{cs.name}"
			    cs.students.count.times do |i|
			    	condition_id = condition_ids[rand(condition_ids.count)]
			    	barcode = rand(9876543210)
			      copy = BookCopy.new(
			        book_condition_id: condition_id,
			        copy_no: cs.grade_section.name + "#" + (i+1).to_s,
			        status_id: status.id,
			        barcode: barcode
			      )
			      copy.copy_conditions << CopyCondition.new(
		      		book_condition_id: new_condition_id,
		      		academic_year_id: academic_year_id - 1,
		      		barcode: barcode,
		      		notes: 'Initial condition',
		      		user_id: user.id,
		      		start_date: Date.today - 360
			      )
			      copy.copy_conditions << CopyCondition.new(
		      		book_condition_id: condition_id,
		      		academic_year_id: academic_year_id,
		      		barcode: barcode,
		      		notes: 'Initial condition',
		      		user_id: user.id,
		      		start_date: Date.today
			      )
			      edition.book_copies << copy
			     end
		    end
			end
		end



	end
end