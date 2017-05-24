FactoryGirl.define do
  factory :budget_item do
    budget nil
    description "MyString"
    notes "MyString"
    amount "9.99"
    currency "MyString"
    used_amount "9.99"
    completed false
    appvl_notes "MyString"
    approved false
    approver nil
    date_approved "2017-05-24"
  end
end
