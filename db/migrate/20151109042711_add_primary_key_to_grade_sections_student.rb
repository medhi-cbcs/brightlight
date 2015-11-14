class AddPrimaryKeyToGradeSectionsStudent < ActiveRecord::Migration
  def change
  	add_column :grade_sections_students, :id, :primary_key
  end
end
