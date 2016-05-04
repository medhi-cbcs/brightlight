class CreateGradeSectionHistories < ActiveRecord::Migration
  def change
    create_table :grade_section_histories do |t|
      t.belongs_to :grade_level, index: true#, foreign_key: true
      t.belongs_to :grade_section, index: true#, foreign_key: true
      t.belongs_to :academic_year, index: true#, foreign_key: true
      t.belongs_to :homeroom, index: true#, foreign_key: true
      t.string :name

      t.timestamps null: false
    end
  end
end
