class AddCapacityToGradeSections < ActiveRecord::Migration
  def change
    add_column :grade_sections, :capacity, :integer
    add_column :grade_section_histories, :capacity, :integer
  end
end
