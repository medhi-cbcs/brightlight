class AddDateToProducts < ActiveRecord::Migration
  def change
  	add_column :products, :expiry_date, :string
  	add_column :products, :received_date, :date
  end
end
