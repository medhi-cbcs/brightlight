class ChangeColumnNameInEmployees < ActiveRecord::Migration
  def change
    remove_reference :employees, :person
    add_reference :employees, :user, index: true#, foreign_key: true
  end
end
