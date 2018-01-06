require "json"

module SiteHealth
  module Checkers
    class JSONSyntax < Checker
      def call
        begin
          ::JSON.parse(page.body)
          'OK'
        rescue ::JSON::ParserError => e
          e.message
        end
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
