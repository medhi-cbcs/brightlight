FactoryGirl.define do
  factory :budget do
    department nil
    owner nil
    grade_level nil
    grade_section nil
    academic_year nil
    submitted false
    submit_date "2017-05-24"
    approved false
    apprv_date "2017-05-24"
    approver nil
    type ""
    category "MyString"
    active false
    notes "MyString"
  end
end
