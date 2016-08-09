json.array!(@borrowers) do |borrower|
  json.extract! borrower, :id, :name
end
