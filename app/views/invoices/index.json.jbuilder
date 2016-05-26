json.array!(@invoices) do |invoice|
  json.extract! invoice, :id, :invoice_number, :invoice_date, :bill_to, :student_id, :grade_section, :roster_no, :total_amount, :received_by, :paid_by, :paid_amount, :currency, :notes, :user_id
  json.url invoice_url(invoice, format: :json)
end
