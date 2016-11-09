class ChangeColumnNameInGuardian < ActiveRecord::Migration
  def change
    rename_column :guardians, :family_no, :family_id
  end
end
