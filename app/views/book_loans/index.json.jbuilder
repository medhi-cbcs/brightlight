json.array!(@book_loans) do |book_loan|
  json.extract! book_loan, :id, :book_copy_id, :book_edition_id, :book_title_id, :user_id, :book_category_id, :loan_type_id, :out_date, :due_date, :academic_year_id
  json.url book_loan_url(book_loan, format: :json)
end
