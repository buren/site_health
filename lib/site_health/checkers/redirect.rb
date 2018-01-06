module SiteHealth
  module Checkers
    # Checks if page is a redirect (works with HTTP 3XX status and HTML body redirects)
    class Redirect < Checker
      # @return [Boolean] determines whether the page is a redirect (HTTP 3XX or HTML meta redirect)
      def call
        page.redirect?
      end

      # @return [Array<Symbol>] list of page types the checker will run on
      def name
        "redirect"
      end
    end
  end
end
