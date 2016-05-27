class Template < ActiveRecord::Base
  belongs_to :academic_year
  belongs_to :user

  # Set template.placeholders to a hash, such as {student_no:3, student_name:'Annie',receipt_date:Date.today}
  attr_accessor :placeholders

  def method_missing(meth)
    if method = meth.to_s.match(/substituted_(.*)/)
      if str = self[method[1]]
        self.placeholders.each do |key, value|
          next if key.blank?
          placeholder = "##{key.to_s}#"
          str.gsub!(placeholder, value.to_s || '')
        end
        return str
      else
        super
      end
    else
      super
    end
  end

end
