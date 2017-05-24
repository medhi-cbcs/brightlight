json.array!(@order_items) do |order_item|
  json.extract! order_item, :id, :purchase_order_id, :no, :order_date, :supplier, :supplier_id, :req_line_id, :invoice_amt, :dp_amount, :dp_date, :notes
  json.url order_item_url(order_item, format: :json)
end
