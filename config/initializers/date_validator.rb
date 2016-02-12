# Validates that the record has string in date format

class DateValidator < ActiveModel::EachValidator
	us_date_format = false

	def validate_each(record, attribute, value)
		unless string_to_date(value) 
			record.errors[attribute] << (options[:message] || "is not a valid date")
		end
	end

	private

	def string_to_date(value)
    return if value.blank?
    return value if value.is_a?(Date)
    return value.to_date if value.is_a?(Time) || value.is_a?(DateTime)
    
    year, month, day = case value.to_s.strip
      # 22/1/06, 22\1\06 or 22.1.06
      when /\A(\d{1,2})[\\\/\.-](\d{1,2})[\\\/\.-](\d{2}|\d{4})\Z/
        self.us_date_format ? [$3, $1, $2] : [$3, $2, $1]
      # 22 Feb 06 or 1 jun 2001
      when /\A(\d{1,2}) (\w{3,9}) (\d{2}|\d{4})\Z/
        [$3, $2, $1]
      # July 1 2005
      when /\A(\w{3,9}) (\d{1,2})\,? (\d{2}|\d{4})\Z/
        [$3, $1, $2]
      # 2006-01-01
      when /\A(\d{4})-(\d{2})-(\d{2})\Z/
        [$1, $2, $3]
      # 2006-01-01T10:10:10+13:00
      when /\A(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})\Z/
        [$1, $2, $3]
      # Not a valid date string
      else
        return nil
    end
    
    Date.new(unambiguous_year(year), month_index(month), day.to_i) rescue nil
  end

  def unambiguous_year(year)
    year = "#{year.to_i < 20 ? '20' : '19'}#{year}" if year.length == 2
    year.to_i
  end

  def month_index(month)
    return month.to_i if month.to_i.nonzero?
    Date::ABBR_MONTHNAMES.index(month.capitalize) || Date::MONTHNAMES.index(month.capitalize)
  end
end