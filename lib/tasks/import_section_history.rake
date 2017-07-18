namespace :data do
	desc "Import section history"
	task import_section_history: :environment do

    GradeSection.all.order(:grade_level_id, :id).each do |section|
      ["2010-2011", "2011-2012", "2012-2013", "2013-2014", "2014-2015"].each do |year|
        section.grade_section_histories << GradeSectionHistory.new(
          grade_level: section.grade_level,
          academic_year: AcademicYear.find_by_name(year),
          name: section.name,
          subject_code: section.subject_code,
          parallel_code: section.parallel_code
        )
        puts "#{section.grade_section_histories.last.name} #{section.grade_section_histories.last.academic_year.name}"
				section.save
      end
		end
  end
end
