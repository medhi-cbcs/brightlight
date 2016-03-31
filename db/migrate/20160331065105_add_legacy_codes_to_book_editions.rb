class AddLegacyCodesToBookEditions < ActiveRecord::Migration
  def change
    add_column :book_editions, :legacy_code, :string
  end
end
