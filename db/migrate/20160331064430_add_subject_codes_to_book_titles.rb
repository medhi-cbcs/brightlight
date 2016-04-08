class AddSubjectCodesToBookTitles < ActiveRecord::Migration
  def change
    add_column :book_titles, :subject_level, :string
    add_column :book_titles, :grade_code, :string
  end
end
