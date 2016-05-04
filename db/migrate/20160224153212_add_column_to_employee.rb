class AddColumnToEmployee < ActiveRecord::Migration
  def change
    add_reference :employees, :person, index: true#, foreign_key: true
  end
end
