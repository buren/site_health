module SiteHealth
  module Checkers
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
