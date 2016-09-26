class CreatePassengers < ActiveRecord::Migration
  def change
    create_table :passengers do |t|
      t.references :transport, index: true, foreign_key: true
      t.references :student, index:true, foreign_key: true
      t.string :name
      t.string :family_no, index: true
      t.integer :family_id
      t.references :grade_section, index: true, foreign_key: true
      t.string :class_name
      t.boolean :active
      t.string :notes

      t.timestamps null: false
    end
  end
end
