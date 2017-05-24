FactoryGirl.define do
  factory :order_item do
    purchase_order nil
    no 1
    order_date "2017-05-24"
    supplier "MyString"
    supplier_id 1
    req_line nil
    invoice_amt "9.99"
    dp_amount "9.99"
    dp_date "2017-05-24"
    notes "MyString"
  end
end
