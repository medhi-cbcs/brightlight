json.array!(@templates) do |template|
  json.extract! template, :id, :name, :header, :opening, :body, :closing, :footer, :target, :group, :category, :active, :academic_year_id, :user_id, :language
  json.url template_url(template, format: :json)
end
