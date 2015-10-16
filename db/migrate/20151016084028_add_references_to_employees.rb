class AddReferencesToEmployees < ActiveRecord::Migration
  def up
  	remove_column :employees, :reporting_supervisor_id
  	remove_column :employees, :department_id
  	add_reference :employees, :supervisor, index: true
  	add_reference :employees, :department, index: true, foreign_key: true 
  end
  def down
  	add_column :employees, :reporting_supervisor_id, :integer
  	add_column :employees, :department_id, :integer
  	remove_reference :employees, :supervisor 
  	remove_reference :employees, :department 
  end
end
