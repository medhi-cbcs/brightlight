class AddPrimaryKeyToCoursesSections < ActiveRecord::Migration
  def change
  	add_column :courses_sections, :id, :primary_key
  end
end
