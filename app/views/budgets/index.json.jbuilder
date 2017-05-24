json.array!(@budgets) do |budget|
  json.extract! budget, :id, :department_id, :owner_id, :grade_level_id, :grade_section_id, :academic_year_id, :submitted, :submit_date, :approved, :apprv_date, :approver_id, :type, :category, :active, :notes
  json.url budget_url(budget, format: :json)
end
