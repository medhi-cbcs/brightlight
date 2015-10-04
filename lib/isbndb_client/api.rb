require 'isbndb_client/access_key_set'
require 'isbndb_client/api/isbndb_book'
require 'isbndb_client/api/isbndb_response'

module ISBNDBClient
  # A simple wrapper around the Google Books API
  module API
    include HTTParty
    base_uri 'http://isbndb.com/api/v2/json'

    Error = Class.new(StandardError)

    class << self

      # The search parameters.
      attr_accessor :parameters

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

        ISBNDBResponse.new request("#{access_key_set.current_key}/books", parameters)
      end

      # Query the Google Books API to find a book by its unique VolumeID.
      #
      # The options hash respects the following members:
      #
      # * `:api_key`, your ISBNdb.com API key.
      def find(id)
        response = get("/#{access_key_set.current_key}/book/#{id}")
        ISBNDBBook.new response
      end

      private

      def request(path, parameters)
        query = parameters ? URI.encode_www_form(parameters) : ""
        HTTParty.get(path, { query: query }).tap do |response|
          raise Error, response['error']['message'] if response.has_key?('error')
        end
      end

      def access_key_set
        @@access_key_set ||= ISBNDBClient::AccessKeySet.new
      end


    end
  end
end