module SiteHealth
  module Checkers
    class MissingTitle < Checker
      def call
        return false if page.redirect?

        page.title.to_s.strip.empty?
      end

      def name
        "missing_title"
      end

      def types
        %i[html]
      end
    end
  end
end