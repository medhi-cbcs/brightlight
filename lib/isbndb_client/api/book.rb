require 'hashie'

module ISBNDBClient
	module API
		class Book
			attr_reader :title, :authors, :publisher, :published_date,
                  :isbn, :isbn10, :dewey, :summary, :notes, :book_id, 
                  :edition_info, :physical_description, :subject_ids                 

      def initialize(item)
        return if item.nil?
        parse_item(item)
      end

      private

      def parse_item(item)
        @book = Hashie::Mash.new item
        
        @book_id = @book.book_id
        @title = @book.title
        @authors = @book.authors || []
        @publisher = @book.publisher
        @published_date = extract_date @book.edition_info
        @description = @book.summary
        @isbn = @book.isbn
        @isbn10 = @book.isbn10
        @dewey = @book.dewey_decimal
        @page_count = extract_page_count @book.physical_description_text
        @notes = @book.notes
        @edition_info = @book.edition_info
        @physical_description = @book.physical_description_text
        @subject_ids = @book.subject_ids || []
      end

      # Extract date from the edition_info data
      # "Paperback; 2004-10-15"
      #
      def extract_date(info)
      	edition, published_date = info.split(/; /)
      	published_date
      end

      # Extract page count from physical description text
      # 7.3\"x8.8\"x1.8\"; 2.8 lb; 784 pages"
      def extract_page_count(info)
      	dimension, weight, pages = info.split(/; /)
      	page_count, pp = pages.split(/ /)
      	page_count
      end
		end
	end
end
