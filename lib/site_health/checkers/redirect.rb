module SiteHealth
  module Checkers
    # Checks if page is a redirect (works with HTTP 3XX status and HTML body redirects)
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
