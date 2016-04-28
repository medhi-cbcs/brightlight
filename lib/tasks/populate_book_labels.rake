namespace :db do
	desc "Populate database with book labels"
	task populate_book_labels: :environment do

		BookLabel.delete_all

		GradeLevel.all.each do |grade|
      grade.grade_sections.each do |section|
        15.times do |i|
          BookLabel.create(grade_level_id:grade.id, name:"#{section.name}##{i.to_s}")
        end
      end
		end
	end
end
