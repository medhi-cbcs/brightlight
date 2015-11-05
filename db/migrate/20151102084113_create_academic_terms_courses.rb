class CreateAcademicTermsCourses < ActiveRecord::Migration
  def change
    create_table :academic_terms_courses, id: false do |t|
    	t.references :academic_term, index: true
    	t.references :course, index: true
    end
  end
end
