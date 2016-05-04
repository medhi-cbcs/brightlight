class CreateBookLabels < ActiveRecord::Migration
  def change
    create_table :book_labels do |t|
      t.belongs_to :grade_section, index: true#, foreign_key: true
      t.belongs_to :student, index: true#, foreign_key: true
      t.string :name

      t.timestamps null: false
    end
  end
end
