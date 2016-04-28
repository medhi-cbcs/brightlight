class AddColummnToBookCondition < ActiveRecord::Migration
  def change
    add_column :book_conditions, :color, :string
  end
end
