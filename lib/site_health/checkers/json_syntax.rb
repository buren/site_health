require "json"

module SiteHealth
  module Checkers
    class JSONSyntax < Checker
      def call
        errors = []
        error_message = validate_json(page.body)
        errors << error_message if error_message

        { errors: errors }
      end

      def name
        "json_syntax"
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
