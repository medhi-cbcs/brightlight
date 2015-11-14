module ApplicationHelper
  def logo
    image_tag("logo.png", alt: "Brightlight")
  end

  def current_academic_year_id
  	session[:year_id] ||= AcademicYear.current.first.id
  end
end
