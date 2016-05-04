class CreateStudentAdmissionInfos < ActiveRecord::Migration
  def change
    create_table :student_admission_infos do |t|
      t.belongs_to :student, index: true#, foreign_key: true
      t.belongs_to :academic_year, index: true#, foreign_key: true
      t.string :skhun
      t.string :skhun_date
      t.string :diploma
      t.string :diploma_date
      t.string :acceptance_date_1
      t.string :acceptance_date_2
      t.string :nisn
      t.string :duration
      t.string :reason
      t.string :status
      t.string :notes
      t.string :prev_sch_name
      t.string :prev_sch_grade
      t.string :prev_sch_address

      t.timestamps null: false
    end
  end
end
