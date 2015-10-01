module ISBNDBClient
  # A simple wrapper around the Google Books API
  module API
    include HTTParty
    base_uri 'http://isbndb.com/api/v2/json/'

    Error = Class.new(StandardError)

    class << self

      # Queries the ISBNDB.com API. Takes a query string and an
      # optional options hash.
      #
      # The options hash respects the following members:
      #
      # * `:page`, which specifies the page.
      #
      # * `:api_key`, your ISBNdb.com API key.
      def search(query, opts = {})
        parameters = { 'q' => query }
        parameters['p'] = opts[:page]  if opts[:page]

        Response.new request("#{opts[:api_key]}/books", parameters)
      end

      # Query the Google Books API to find a book by its unique VolumeID.
      #
      # The options hash respects the following members:
      #
      # * `:api_key`, your ISBNdb.com API key.
      def find(id, opts = {})

        Book.new request("#{opts[:api_key]}/book/#{id}")
      end

      private

      def request(path, parameters)
        query = parameters ? URI.encode_www_form parameters : ""
        get(path, { query: query }).tap do |response|
          raise Error, response['error']['message'] if response.has_key?('error')
        end
      end
    end
  end
end