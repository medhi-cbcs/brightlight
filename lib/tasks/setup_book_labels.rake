namespace :data do
	desc "Setup book labels"
	task setup_book_labels: :environment do
    GradeSection.all.order(:grade_level_id, :id).each do |grade_section|
      existing_label_numbers = grade_section.book_labels.collect(&:book_no)
      (1..grade_section.capacity).each_with_index do |i|
        name = if grade_section.grade_level_id > 12
                 "#{grade_section.name}##{i}"
               else
                 "#{grade_section.name.match(/Grade (.+)/)[1]}##{i}"
               end
        unless existing_label_numbers.include? i
          grade_section.book_labels.create name:name, book_no:i, grade_level_id:grade_section.grade_level_id
          puts "#{grade_section.name}: #{i}"
        end
      end
    end
  end
end
