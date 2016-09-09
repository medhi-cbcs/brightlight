# For sorting list in a table
module SortableColumns
  extend ActiveSupport::Concern

  included do
    def self.sortable_columns(*columns)
      @@sortable_columns = columns.map { |column| column.to_s }
    end 
  end

  def sort_column
    @@sortable_columns.include?(params[:column]) ? params[:column] : @@sortable_columns.first
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end