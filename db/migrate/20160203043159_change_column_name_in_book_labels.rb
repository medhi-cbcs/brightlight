class ChangeColumnNameInBookLabels < ActiveRecord::Migration
  def change
    rename_column :book_labels, :grade_section_id, :grade_level_id
  end
end
