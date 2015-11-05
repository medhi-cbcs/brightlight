class AddPrimaryKeyToBookCondition < ActiveRecord::Migration
  def change
  	add_column :book_conditions, :id, :primary_key
  end
end
