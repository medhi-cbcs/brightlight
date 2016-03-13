class AddSlugToBookCondition < ActiveRecord::Migration
  def change
    add_column :book_conditions, :slug, :string
    add_index  :book_conditions, :slug, :unique => true
  end
end
