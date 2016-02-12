class CreateSchoolTerms < ActiveRecord::Migration
  def change
    create_table :school_terms do |t|
      t.belongs_to :academic_year, index: true, foreign_key: true
      t.string :name
      t.date :start_date
      t.date :end_date

      t.timestamps null: false
    end
  end
end
