json.array!(@budget_items) do |budget_item|
  json.extract! budget_item, :id, :budget_id, :description, :notes, :amount, :currency, :used_amount, :completed, :appvl_notes, :approved, :approver_id, :date_approved
  json.url budget_item_url(budget_item, format: :json)
end
