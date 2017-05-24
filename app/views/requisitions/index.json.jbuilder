json.array!(@requisitions) do |requisition|
  json.extract! requisition, :id, :req_no, :department_id, :requester_id, :supv_approved, :supv_notes, :notes, :budgetted, :budget_approved, :bdgt_appvd_by_id, :bdgt_appvd_name, :bdgt_appv_notes, :sent_purch, :sent_supv, :date_sent_supv, :sent_bdgt_appv, :date_sent_bdgt, :date_supv_appvl, :date_bdgt_appvl, :notes, :origin
  json.url requisition_url(requisition, format: :json)
end
