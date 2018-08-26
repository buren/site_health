# frozen_string_literal: true

module SiteHealth
  # Checks if HTML-meta title is present
  class MissingTitle < Checker
    name 'missing_title'
    types 'html'

    def check
      # @return [Boolean] determines whether the title is missing
      return add_data(missing: false) if page.redirect?

      missing_title = page.title.to_s.strip.empty?
      add_data(missing: missing_title)

      if missing_title
        add_issue(title: 'missing title', severity: :medium, priority: :high)
      end
    end
  end

  SiteHealth.register_checker(MissingTitle)
end
