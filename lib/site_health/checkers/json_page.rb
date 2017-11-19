require "json"

module SiteHealth
  module Checkers
    class JSONPage
      def self.check(page)
        new(page).check
      end

      attr_reader :page, :url

      # @param [Spidr::Page] the crawled page
      def initialize(page)
        @page = page
        @url = page.url
      end

      def check
        error_message = validate_json(page.body)

        errors = []
        errors << error_message if error_message

        JSONJournal.new(url: url, page: page, errors: errors)
      end

      def validate_json(string)
        begin
          JSON.parse(string)
          nil
        rescue JSON::ParserError => e
          e.message
        end
      end
    end
  end
end
