namespace :db do
	desc "Populate database with book copies"
	task populate_book_copies: :environment do
		
		BookCopy.delete_all

		BookTitle.find_each do |book|
			number = book.courses.map{|course| course.course_sections.map {|cs| cs.students.count}}.flatten.sum
			book.book_editions.find_each do |edition|
				edition.create_book_copies(number)
			end
		end
	end
end