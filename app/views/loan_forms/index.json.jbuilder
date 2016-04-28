json.array!(@loan_forms) do |loan_form|
  json.extract! loan_form, :id
  json.url loan_form_url(loan_form, format: :json)
end
