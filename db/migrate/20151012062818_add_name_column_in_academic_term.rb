class AddNameColumnInAcademicTerm < ActiveRecord::Migration
  def change
  	add_column :academic_terms, :name, :string
  end
end
