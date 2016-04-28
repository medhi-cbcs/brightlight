class AddPercentageInBookFine < ActiveRecord::Migration
  def change
    add_column :book_fines, :percentage, :float
    add_column :book_fines, :currency, :string
  end
end
