class CreateRequisitions < ActiveRecord::Migration
  def change
    create_table :requisitions do |t|
      t.string :req_no
      t.belongs_to :department, index: true, foreign_key: true
      t.belongs_to :requester, index: true, foreign_key: true
      t.boolean :supv_approved
      t.string :supv_notes
      t.string :notes
      t.boolean :budgetted
      t.boolean :budget_approved
      t.belongs_to :bdgt_appvd_by, index: true, foreign_key: true
      t.string :bdgt_appvd_name
      t.string :bdgt_appv_notes
      t.boolean :sent_purch
      t.boolean :sent_supv
      t.date :date_sent_supv
      t.boolean :sent_bdgt_appv
      t.date :date_sent_bdgt
      t.date :date_supv_appvl
      t.date :date_bdgt_appvl
      t.string :notes
      t.string :origin

      t.timestamps null: false
    end
  end
end
