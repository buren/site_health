module SiteHealth
  module Checkers
    class Redirect < Checker
      def call
        page.redirect?
      end

      def name
        "redirect"
      end
    end
  end
end
