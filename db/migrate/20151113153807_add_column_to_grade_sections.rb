class AddColumnToGradeSections < ActiveRecord::Migration
  def change
    add_reference :grade_sections, :academic_year, index: true#, foreign_key: true
  end
end
