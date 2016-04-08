class AddDeletedFlagToCopyConditions < ActiveRecord::Migration
  def change
    add_column :copy_conditions, :deleted_flag, :boolean
  end
end
