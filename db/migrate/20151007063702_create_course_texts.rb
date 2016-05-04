class CreateCourseTexts < ActiveRecord::Migration
  def change
    create_table :course_texts, id: false do |t|
      t.belongs_to :course, index: true#, foreign_key: true
      t.belongs_to :book_title, index: true#, foreign_key: true
      t.integer :order_no
    end
  end
end
