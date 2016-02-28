class CreateFineScales < ActiveRecord::Migration
  def change
    create_table :fine_scales do |t|
      t.belongs_to :old_condition, index: true, foreign_key: true
      t.belongs_to :new_condition, index: true, foreign_key: true
      t.float :percentage

      t.timestamps null: false
    end
  end
end
