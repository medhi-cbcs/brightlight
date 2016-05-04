class ChangeGraduationDateTypesInEmployees < ActiveRecord::Migration
  def up
    change_column :employees, :education_graduation_date, 'date USING CAST(education_graduation_date AS date)'
    change_column :employees, :education_graduation_date2, 'date USING CAST(education_graduation_date2 AS date)'
  end

  def down
    change_column :employees, :education_graduation_date, :string
    change_column :employees, :education_graduation_date2, :string
  end
end
