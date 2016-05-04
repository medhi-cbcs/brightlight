class AddColumnToGuardian < ActiveRecord::Migration
  def change
    add_reference :guardians, :person, index: true#, foreign_key: true
  end
end
