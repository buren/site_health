module SiteHealth
  module Checkers
    # Checks for XML-errors (backed by the excellent Nokogiri gem)
    class XML < Checker
      def call
        page.doc.errors.map(&:to_s)
      end

      def name
        "xml"
      end

      def types
        %i[xml]
      end
    end
  end
end
