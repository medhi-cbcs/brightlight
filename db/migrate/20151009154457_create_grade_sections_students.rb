class CreateGradeSectionsStudents < ActiveRecord::Migration
  def change
    create_table :grade_sections_students, id: false do |t|
      t.belongs_to :grade_section, index: true, foreign_key: true
      t.belongs_to :student, index: true, foreign_key: true
      t.integer :order_no

      t.timestamps null: false
    end
  end
end
