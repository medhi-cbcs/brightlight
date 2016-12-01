class DropTableStudentsGuardians < ActiveRecord::Migration
  def up
    drop_table :students_guardians
  end

  def down
    create_table :students_guardians, id: false do |t|
      t.belongs_to :student, index: true#, foreign_key: true
      t.belongs_to :guardian, index: true#, foreign_key: true
      t.string :relation

      t.timestamps null: false
    end
  end
end
