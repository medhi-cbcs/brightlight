class AddColumnsToGradeSections < ActiveRecord::Migration
  def change
    add_reference :grade_sections, :assistant, index: true, foreign_key: true
    add_column :grade_sections, :subject_code, :string
    add_column :grade_sections, :parallel_code, :string
    add_column :grade_sections, :notes, :string

    add_reference :grade_section_histories, :assistant, index: true, foreign_key: true
    add_column :grade_section_histories, :subject_code, :string
    add_column :grade_section_histories, :parallel_code, :string
    add_column :grade_section_histories, :notes, :string
  end
end
