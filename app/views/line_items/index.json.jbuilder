json.array!(@line_items) do |line_item|
  json.extract! line_item, :id, :description, :quantity, :price, :ext1, :ext2, :ext3, :invoice_id
  json.url line_item_url(line_item, format: :json)
end
