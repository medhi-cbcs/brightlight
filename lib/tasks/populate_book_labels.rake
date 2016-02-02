namespace :db do
	desc "Populate database with book labels"
	task populate_book_labels: :environment do

		BookLabel.delete_all

		GradeLevel.all.each do |grade|
      grade.grade_sections.each do |section|
        25.times do |i|
          BookLabel.create(grade_section_id:section.id, name:"#{section.name}##{i.to_s}")
        end
      end
		end
	end
end
