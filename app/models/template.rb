class Template < ActiveRecord::Base
  belongs_to :academic_year
  belongs_to :user

  # Set template.placeholders to a hash, such as {student_no:3, student_name:'Annie',receipt_date:Date.today}
  attr_accessor :placeholders

  # def method_missing(meth)
  #   if method = meth.to_s.match(/substituted_(.*)/)
  #     if str = self[method[1]]
  #       self.placeholders.each do |key, value|
  #         next if key.blank?
  #         placeholder = "##{key.to_s}#"
  #         str.gsub!(placeholder, value.to_s || '')
  #       end
  #       return str
  #     else
  #       super
  #     end
  #   else
  #     super
  #   end
  # end

  def substituted(section, options={})
    if self.respond_to? section
      text = String.new self.method(section).call
      if self.placeholders.present?
        self.placeholders.merge!(options)
        self.placeholders.each do |key, value|
          next if key.blank?
          placeholder = "##{key.to_s}#"
          text.gsub!(placeholder, value.to_s || '')
        end
      end
      img_match = text.match(/img.*src=\"([^ ]+)\"/)
      if options[:pdf]==true && img_match.present?
        url_match = img_match[1].match /.+assets\/([a-zA-Z0-9-]+)-([a-z0-9]+)\.(jpg|png)/
        # text.gsub! match[2], "file:////#{Rails.root}/app/assets/images"
        if url_match.present?
          text.gsub! img_match[1], "file:///#{Rails.root}/app/assets/images/#{url_match[1]}.#{url_match[3]}"
        end
      end
      return text.html_safe
    end
  end

end
