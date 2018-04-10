module SiteHealth
  # Checks if page is a redirect (works with HTTP 3XX status and HTML body redirects)
  class Redirect < Checker
    name "redirect"

    def check
      # @return [Boolean] determines whether the page is a redirect (HTTP 3XX or HTML meta redirect)
      add_data(redirect: page.redirect?)
    end
  end
end
