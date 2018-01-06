require "json"

module SiteHealth
  module Checkers
    # Checks if JSON syntax is valid
    class JSONSyntax < Checker
      def call
        ::JSON.parse(page.body)
        'OK'
      rescue ::JSON::ParserError => e
        e.message
      end

      def name
        "json_syntax"
      end

      def types
        %i[json]
      end
    end
  end
end
