namespace :data do
	desc "Populate models with slugs data"
	task init_slugs: :environment do

    AcademicYear.all.each {|x| x.reset_slug; x.save }
		GradeLevel.all.each {|x| x.reset_slug; x.save }
		GradeSection.all.order(:grade_level_id, :id).each {|x| x.reset_slug; x.save }
		BookCondition.all.each {|x| x.reset_slug; x.save }
		BookEdition.all.each {|x| x.reset_slug; x.save }

  end
end
