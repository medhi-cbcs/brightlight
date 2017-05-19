if @smart_card
  json.smart_card do 
    json.id             @smart_card.id
    json.code           @smart_card.code
    json.transport_id   @smart_card.transport_id
    json.transport_name @smart_card.try(:transport).try(:name)
    json.category       @smart_card.try(:transport).try(:category)
    json.detail         @smart_card.detail
    json.ref            @smart_card.ref 
  end 
else
  json.new_card do 
    json.code           @code
  end
end 
 