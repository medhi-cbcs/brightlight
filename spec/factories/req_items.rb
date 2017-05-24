FactoryGirl.define do
  factory :req_item do
    requisition nil
    description "MyString"
    qty_reqd 1.5
    unit "MyString"
    est_price "9.99"
    actual_price "9.99"
    notes "MyString"
    date_needed "2017-05-24"
    budgetted false
    budget_item nil
    budget_name "MyString"
    bdgt_approved false
    bdgt_notes "MyString"
    bdgt_appvl_by nil
  end
end
