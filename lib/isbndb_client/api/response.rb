module ISBNDBClient
  module API
    class Response
      include Enumerable
      
      def initialize(results)
        @results = results
      end
      
      # Iterator for looping through the results
      def each(&block)
        @results['data'].each do |item|
          block.call(Book.new(item))
        end
      end
      
      # Error message
      def error_message
        @results['error']
      end

      def error?
        !error_message.nil?
      end
    end
  end
end