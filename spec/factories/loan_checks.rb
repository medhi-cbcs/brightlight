FactoryGirl.define do
  factory :loan_check do
    book_loan nil
    book_copy nil
    user nil
    loaned_to 1
    scanned_for 1
    academic_year nil
    emp_flag false
    valid false
    notes "MyString"
  end
end
