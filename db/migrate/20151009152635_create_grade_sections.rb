class CreateGradeSections < ActiveRecord::Migration
  def change
    create_table :grade_sections do |t|
      t.belongs_to :grade_level, index: true, foreign_key: true
      t.string :name
      t.string :homeroom

      t.timestamps null: false
    end
  end
end
