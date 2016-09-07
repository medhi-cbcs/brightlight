module UsersHelper
  def sort_link(column, title = nil)
   title ||= column.titleize
   direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
   icon = sort_direction == "asc" ? "keyboard_arrow_up" : "keyboard_arrow_down"
   icon = column == sort_column ? icon : ""
   link_to "#{title} <i class='material-icons vmiddle'>#{icon}</i>".html_safe, {column: column, direction: direction}
  end
end
