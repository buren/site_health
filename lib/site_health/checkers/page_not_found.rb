# frozen_string_literal: true

module SiteHealth
  # Checks if HTML-meta title is present
  class PageNotFound < Checker
    name 'page_not_found'

    def check
      if page.missing?
        add_data(not_found: true)
        add_issue(title: 'page not found', severity: :major, priority: :high)
        return
      end

      add_data(not_found: false)
    end
  end

  SiteHealth.register_checker(PageNotFound)
end
