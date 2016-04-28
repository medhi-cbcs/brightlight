class AddColumnsToGradeLevel < ActiveRecord::Migration
  def change
    add_reference :grade_levels, :school_level, index: true, foreign_key: true
    add_column :grade_levels, :code, :string
  end
end
