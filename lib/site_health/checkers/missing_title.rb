# frozen_string_literal: true

module SiteHealth
  # Checks if HTML-meta title is present
  class MissingTitle < Checker
    name 'missing_title'
    types 'html'
    issue_types({
      _default: {
        severity: :major,
        priority: :high,
        links: [{ href: 'https://moz.com/learn/seo/title-tag' }]
      },
      missing: {
        title: 'title missing',
        detail: 'titles are important for SEO'

      },
      too_long: {
        title: 'title too long',
        detail: 'keep titles under 60 characters - titles are important for SEO',
      },
    })

    def check
      return if page.redirect?

      title = page.title.to_s.strip

      if title.empty?
        add_issue_type(:missing)
      elsif title.length > 60
        add_issue_type(:too_long)
      end
    end
  end

  SiteHealth.register_checker(MissingTitle)
end
