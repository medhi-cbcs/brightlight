class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.string :code
      t.string :name
      t.string :description

      t.timestamps null: false
    end
  end
end
