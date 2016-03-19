namespace :data do
	desc "Populate models with slugs data"
	task init_slugs: :environment do

    AcademicYear.all.each do |year|
      year.reset_slug
      year.save
    end

  end
end
