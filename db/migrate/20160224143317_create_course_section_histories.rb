class CreateCourseSectionHistories < ActiveRecord::Migration
  def change
    create_table :course_section_histories do |t|
      t.string :name
      t.belongs_to :course, index: true, foreign_key: true
      t.belongs_to :grade_section, index: true, foreign_key: true
      t.belongs_to :instructor, index: true, foreign_key: true
      t.belongs_to :academic_year, index: true, foreign_key: true
      t.belongs_to :academic_term, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
