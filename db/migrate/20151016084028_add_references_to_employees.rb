class AddReferencesToEmployees < ActiveRecord::Migration
  def change
  	remove_column :employees, :reporting_supervisor_id
  	remove_column :employees, :department_id
  	add_reference :employees, :supervisor, index: true
  	add_reference :employees, :department, index: true#, foreign_key: true 
  end
end
