class CreateStudentsGuardians < ActiveRecord::Migration
  def change
    create_table :students_guardians do |t|
      t.belongs_to :student, index: true, foreign_key: true
      t.belongs_to :guardian, index: true, foreign_key: true
      t.string :relation

      t.timestamps null: false
    end
  end
end
