module ApplicationHelper
  def logo
    image_tag("logo.png", alt: "Brightlight")
  end

  def current_academic_year_id
  	session[:year_id] ||= AcademicYear.current_id
  end

  # For wicked_pdf gem
  def self.asset_data_base64(path)
    asset = Rails.application.assets.find_asset(path)
    throw "Could not find asset '#{path}'" if asset.nil?
    base64 = Base64.encode64(asset.to_s).gsub(/\s+/, "")
    "data:#{asset.content_type};base64,#{Rack::Utils.escape(base64)}"
  end
  
end
