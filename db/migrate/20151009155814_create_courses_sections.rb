class CreateCoursesSections < ActiveRecord::Migration
  def change
    create_table :courses_sections do |t|
      t.string :name
      t.belongs_to :course, index: true, foreign_key: true
      t.belongs_to :grade_section, index: true, foreign_key: true
      t.string :instructor
      t.references :employee, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
