class AddColumnToStudent < ActiveRecord::Migration
  def change
    add_reference :students, :person, index: true, foreign_key: true
  end
end
