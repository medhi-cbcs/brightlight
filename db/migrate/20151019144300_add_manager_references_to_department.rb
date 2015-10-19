class AddManagerReferencesToDepartment < ActiveRecord::Migration
  def change
  	remove_column :departments, :manager
  	add_reference :departments, :manager, index: true, foreign_key: true 
  end
end
