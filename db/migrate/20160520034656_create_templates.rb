class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.string :name
      t.string :header
      t.string :opening
      t.string :body
      t.string :closing
      t.string :footer
      t.string :target
      t.string :group
      t.string :category
      t.string :active
      t.references :academic_year, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.string :language

      t.timestamps null: false
    end
  end
end
