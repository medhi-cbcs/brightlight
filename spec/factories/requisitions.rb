FactoryGirl.define do
  factory :requisition do
    req_no "MyString"
    department nil
    requester nil
    supv_approved false
    supv_notes "MyString"
    notes "MyString"
    budgetted false
    budget_approved false
    bdgt_appvd_by nil
    bdgt_appvd_name "MyString"
    bdgt_appv_notes "MyString"
    sent_purch false
    sent_supv false
    date_sent_supv "2017-05-24"
    sent_bdgt_appv false
    date_sent_bdgt "2017-05-24"
    date_supv_appvl "2017-05-24"
    date_bdgt_appvl "2017-05-24"
    notes "MyString"
    origin "MyString"
  end
end
