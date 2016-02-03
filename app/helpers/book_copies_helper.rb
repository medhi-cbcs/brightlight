module BookCopiesHelper
  def option_for_select_with_class(collection, id, name, selected)
    collection.all.reduce("") do |a,item|
      a+"<option class:'grade#{item.grade_level.id}' "+ (item.name==selected ? "selected" : "") + ">" + item.name + "</option>"
    end.html_safe
  end
end
