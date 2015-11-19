module ISBNDBClient
	module API
		class ISBNDBBook
			attr_reader :title, :authors, :publisher, :published_date, :description,
                  :isbn, :isbn10, :dewey, :summary, :notes, :book_id, :page_count,
                  :edition_info, :physical_description, :subject_ids                 

      def initialize(item)
        return if item.nil?
        parse_item(item)
      end

      private

      # Parses the response that HTTParty.get gets from the ISBNdb web service API
      # parameter: item is the HTTParty::Response object
      def parse_item(item) 
        @book = JSON(item.body)["data"].first     	
        
        # @book = Hashie::Mash.new book_data
        @book_id = @book['book_id']
        @title = @book['title']
        @authors = @book['author_data'] || []
        @publisher = @book['publisher_name']
        @published_date = extract_date @book['edition_info'] if @book['edition_info'].present?
        @description = @book['summary']
        @isbn = @book['isbn']
        @isbn10 = @book['isbn10']
        @dewey = @book['dewey_decimal']
        @page_count = extract_page_count @book['physical_description_text'] if @book['physical_description_text'].present?
        @notes = @book['notes']
        @edition_info = @book['edition_info']
        @physical_description = @book['physical_description_text']
        @subject_ids = @book['subject_ids'] || []
      end

      # Extract date from the edition_info data
      # "Paperback; 2004-10-15"
      #
      def extract_date(info)
      	edition, published_date = info.split(/; /)
        if Date.valid_date? *published_date.split('-').map(&:to_i)
      	  published_date
        else
          nil
        end
      end

      # Extract page count from physical description text
      # 7.3\"x8.8\"x1.8\"; 2.8 lb; 784 pages"
      def extract_page_count(info)
        pages = info.split(/; /).select {|s| /.* pages/.match(s)}.first
        unless pages.nil?
          /([\d]*) pages/.match(pages)[1]
        else
          nil
        end
      end
		end
	end
end
