class CreateBudgets < ActiveRecord::Migration
  def change
    create_table :budgets do |t|
      t.belongs_to :department, index: true, foreign_key: true
      t.belongs_to :owner, index: true, foreign_key: true
      t.references :grade_level, index: true, foreign_key: true
      t.references :grade_section, index: true, foreign_key: true
      t.references :academic_year, index: true, foreign_key: true
      t.boolean :submitted
      t.date :submit_date
      t.boolean :approved
      t.date :apprv_date
      t.references :approver, index: true, foreign_key: true
      t.string :type
      t.string :category
      t.boolean :active
      t.string :notes

      t.timestamps null: false
    end
  end
end
