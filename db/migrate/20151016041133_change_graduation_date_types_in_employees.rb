class ChangeGraduationDateTypesInEmployees < ActiveRecord::Migration
  def up
    change_column :employees, :education_graduation_date, :date
    change_column :employees, :education_graduation_date2, :date
  end

  def down
    change_column :employees, :education_graduation_date, :string
    change_column :employees, :education_graduation_date2, :string
  end
end
