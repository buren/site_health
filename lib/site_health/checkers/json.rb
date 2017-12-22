require "json"

module SiteHealth
  module Checkers
    class JSON < Checker
      def call
        error_message = validate_json(page.body)

        { errors: error_message ? [error_message] : [] }
      end

      def name
        "json"
      end

      def types
        %i[json]
      end

      def validate_json(string)
        begin
          ::JSON.parse(string)
          nil
        rescue ::JSON::ParserError => e
          e.message
        end
      end
    end
  end
end
