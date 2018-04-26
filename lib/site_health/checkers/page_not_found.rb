module SiteHealth
  # Checks if HTML-meta title is present
  class PageNotFound < Checker
    name "page_not_found"

    def check
      # @return [Boolean] determines whether the page returned a HTTP 404 status code
      if page.missing?
        add_data(not_found: true)
        add_issue(title: 'page not found', severity: :major, priority: :high)
      end
    end
  end

  SiteHealth.register_checker(PageNotFound)
end
