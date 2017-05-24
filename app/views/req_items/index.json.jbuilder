json.array!(@req_items) do |req_item|
  json.extract! req_item, :id, :requisition_id, :description, :qty_reqd, :unit, :est_price, :actual_price, :notes, :date_needed, :budgetted, :budget_item_id, :budget_name, :bdgt_approved, :bdgt_notes, :bdgt_appvl_by_id
  json.url req_item_url(req_item, format: :json)
end
