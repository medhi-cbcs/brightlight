class AddPrimaryKeyToCourseTexts < ActiveRecord::Migration
  def change
  	add_column :course_texts, :id, :primary_key
  end
end
