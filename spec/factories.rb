FactoryGirl.define do
  factory :book_condition do 
    factory :new_condition  do code "New" end
    factory :good_condition do code "Good" end 
    factory :fair_condition do code "Fair" end 
    factory :poor_condition do code "Poor" end
    factory :missing_condition do code "Missing" end 
  end 

  factory :status do 
    factory :on_loan do name "On loan" end
    factory :available do name "Available" end
    factory :disposed do name "Disposed" end 
  end

  factory :book_title do
    title     "Narnia"
    authors   "C.S. Lewis"
  end 

  factory :subject do 
    code "S001"
    name "Book Subject"
  end 



  factory :book_edition do 
    book_title
    title     "Narnia"
    authors   "C.S. Lewis"
    sequence(:isbn10) { |n| "0812345#{'%03d'%n}" }
    sequence(:isbn13) { |n| "9781234567#{'%03d'%n}" }
    refno     "9781234567890"
    price     34.4
    currency  "USD"
  end

  factory :book_copy do
    book_edition
    sequence(:barcode) { |n| "INV-111888#{'%02d'%n}" }
    factory :new_book do 
      association :book_condition, factory: :new_condition 
    end 
    factory :good_book do association :book_condition, factory: :good_condition end
    factory :fair_book do association :book_condition, factory: :fair_condition end
    factory :poor_book do association :book_condition, factory: :poor_condition end
    factory :missing_book do association :book_condition, factory: :missing_condition end

    factory :disposed_book do association :status, factory: :disposed end 
    factory :on_loan_book do association :status, factory: :on_loan end 
  end

  factory :academic_year do 
    sequence(:name) { |n| "20#{'%02d' % n} - 20{'%02d' % n+1}" }
  end 
 
  factory :copy_condition do
    book_copy
    academic_year
    book_condition
    user 
    
    trait :starting_condition do
      post 0
    end 
    trait :end_condition do
      post 1
    end 
  end 

  factory :user do
    email     "user@cahayabangsa.org"
    first_name  "Liz"
    last_name   "Claybourne"
    password    "Secret-password!"

    factory :inventory do
      roles_mask  64
    end 

    factory :admin do 
      roles_mask  1
    end

    factory :teacher do 
      roles_mask  8
    end 

    factory :staff do 
      roles_mask  16
    end 
  end 

  factory :employee do 
    name "Liz Claybourne" 
  end 

  factory :student do 
    name "Calvin Kline" 
  end 

  factory :book_loan do 
    book_copy
    book_edition
    book_title 
    barcode { book_copy.barcode }
    academic_year

    factory :teachers_manual do 
      employee
    end 

    factory :students_text do
      student
    end  
  end
end
