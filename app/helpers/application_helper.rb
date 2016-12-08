module ApplicationHelper
  def logo
    image_tag("logo.png", alt: "Brightlight")
  end

  def title(*parts)
    ## Don't forget to set site_name in locales/en.yml, etc.
    content_for(:title) { (parts << t(:site_name)).join(' - ') } unless parts.empty?    
  end

  # For wicked_pdf gem
  def self.asset_data_base64(path)
    asset = Rails.application.assets.find_asset(path)
    throw "Could not find asset '#{path}'" if asset.nil?
    base64 = Base64.encode64(asset.to_s).gsub(/\s+/, "")
    "data:#{asset.content_type};base64,#{Rack::Utils.escape(base64)}"
  end

  def remote_link_to_delete(model, options, &block)
    data_options = {id: model.id, message: options[:message], confirm: 'This will delete selected item. Continue?'}
    css_class = 'delete-link '+options[:class]
    link_to model, data: data_options, method: :delete, remote: true, class: css_class, &block
  end

  def sort_link(column, title = nil)
    column = column.to_s
    sc = sort_column
    title ||= column.titleize
    direction = column == sc && sort_direction == "asc" ? "desc" : "asc"
    icon = sort_direction == "asc" ? "keyboard_arrow_up" : "keyboard_arrow_down"
    icon = column == sc ? icon : ""
    link_to "#{title} <i class='material-icons vmiddle'>#{icon}</i>".html_safe, 
      params.merge({column: column, direction: direction})
  end

end
