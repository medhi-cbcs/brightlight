class ChangeColumnSubjectInBookTitle < ActiveRecord::Migration
  def change
      rename_column :book_titles, :subject, :subject_code
  end
end
