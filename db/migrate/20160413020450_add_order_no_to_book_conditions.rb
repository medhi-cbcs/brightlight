class AddOrderNoToBookConditions < ActiveRecord::Migration
  def change
    add_column :book_conditions, :order_no, :integer
  end
end
