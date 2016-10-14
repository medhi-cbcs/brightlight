json.transport do
  json.id   @transport.id
  json.name @transport.name
  json.category @transport.category
  json.status @transport.status
  json.active @transport.active
  json.notes @transport.notes
  json.active @transport.active
  json.contact_id @transport.contact_id
  json.contact_name @transport.contact_name
  json.contact_phone @transport.contact_phone
  json.contact_email @transport.contact_email
  json.members(@passengers) do |passenger|
    json.id   passenger.id
    json.name passenger.name
    json.family_no passenger.family_no
    json.grade_section_id passenger.grade_section_id
    json.grade passenger.class_name
    json.active passenger.active
  end
end
