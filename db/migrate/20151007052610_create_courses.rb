class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.string :number
      t.string :description
      t.belongs_to :grade_level, index: true#, foreign_key: true
      t.belongs_to :academic_year, index: true#, foreign_key: true
      t.belongs_to :academic_term, index: true#, foreign_key: true
      t.references :employee, index: true#, foreign_key: true

      t.timestamps null: false
    end
  end
end
