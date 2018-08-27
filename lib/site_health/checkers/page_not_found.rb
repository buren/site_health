# frozen_string_literal: true

module SiteHealth
  # Checks if HTML-meta title is present
  class PageNotFound < Checker
    name 'page_not_found'
    issue_types(
      not_found: {
        title: 'Page not found',
        detail: 'The server responded with 404 - page not found.',
        severity: :medium,
        priority: :high,
      }
    )

    protected

    def check
      if page.missing?
        add_data(not_found: true)
        add_issue_type(:not_found)
        return
      end

      add_data(not_found: false)
    end
  end

  SiteHealth.register_checker(PageNotFound)
end
