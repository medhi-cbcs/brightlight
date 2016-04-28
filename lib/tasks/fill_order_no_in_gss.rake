namespace :db do
	desc "Populate grade_sections_students with order no"
	task fill_order_no_in_gss: :environment do

    GradeSection.all.each do |gs|
      gs.grade_sections_students.all.each_with_index do |gss, idx|
        gss.update_attribute(:order_no, idx+1)
      end
    end

  end
end
