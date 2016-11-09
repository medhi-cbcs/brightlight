class CreateFamilyMembers < ActiveRecord::Migration
  def change
    create_table :family_members do |t|
      t.belongs_to :family, index: true, foreign_key: true
      t.references :guardian, index: true, foreign_key: true
      t.references :student, index: true, foreign_key: true
      t.string :relation
      t.string :notes

      t.timestamps null: false
    end
  end
end
