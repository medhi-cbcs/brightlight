class AddNeedsRepairInBookCopy < ActiveRecord::Migration
  def change
    add_column :book_copies, :needs_repair, :boolean
  end
end
