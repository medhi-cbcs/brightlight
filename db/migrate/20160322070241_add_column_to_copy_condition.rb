class AddColumnToCopyCondition < ActiveRecord::Migration
  def change
    add_column :copy_conditions, :post, :integer
  end
end
