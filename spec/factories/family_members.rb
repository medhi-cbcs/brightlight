FactoryGirl.define do
  factory :family_member do
    family nil
    guardian nil
    student nil
    relation "MyString"
    notes "MyString"
  end
end
