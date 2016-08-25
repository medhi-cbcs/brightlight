module ApplicationHelper
  def logo
    image_tag("logo.png", alt: "Brightlight")
  end

  # For wicked_pdf gem
  def self.asset_data_base64(path)
    asset = Rails.application.assets.find_asset(path)
    throw "Could not find asset '#{path}'" if asset.nil?
    base64 = Base64.encode64(asset.to_s).gsub(/\s+/, "")
    "data:#{asset.content_type};base64,#{Rack::Utils.escape(base64)}"
  end

  def remote_link_to_delete(model, options, &block)
    data_options = {id: model.id, message: options[:message], confirm: 'Are you sure?'}
    css_class = 'delete-link '+options[:class]
    link_to model, data: data_options, method: :delete, remote: true, class: css_class, &block
  end

end
