class CreateCourseTexts < ActiveRecord::Migration
  def change
    create_table :course_texts do |t|
      t.string :title
      t.string :author
      t.string :publisher
      t.string :image_url
      t.string :notes
      t.belongs_to :course, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
