class CreateRosters < ActiveRecord::Migration
  def change
    create_table :rosters do |t|
      t.belongs_to :course_section, index: true#, foreign_key: true
      t.belongs_to :student, index: true#, foreign_key: true
      t.references :academic_year, index: true#, foreign_key: true
      t.integer :order_no

      t.timestamps null: false
    end
  end
end
