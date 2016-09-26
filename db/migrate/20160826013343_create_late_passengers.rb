class CreateLatePassengers < ActiveRecord::Migration
  def change
    create_table :late_passengers do |t|
      t.references :carpool, index: true, foreign_key: true
      t.references :transport, index: true, foreign_key: true
      t.references :student, index: true, foreign_key: true
      t.references :grade_section, index: true, foreign_key: true
      t.string :name
      t.string :family_no
      t.integer :family_id
      t.string :class_name
      t.boolean :active
      t.string :notes
      t.datetime :since_time

      t.timestamps null: false
    end
  end
end
