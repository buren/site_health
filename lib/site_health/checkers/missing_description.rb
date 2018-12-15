# frozen_string_literal: true

module SiteHealth
  # Checks if HTML-meta description is present
  class MissingDescription < Checker
    name 'missing_description'
    types 'html'
    issue_types(
      _default: {
        severity: :medium,
        priority: :medium,
        links: [{ href: 'https://moz.com/learn/seo/meta-description' }],
      },
      missing_tag: { title: 'description meta tag missing', priority: :high },
      missing: { title: 'description missing', priority: :high },
      too_long: { title: 'description too long' },
      too_short: { title: 'description too short' }
    )

    protected

    def check
      return if page.redirect?

      description_meta = page.search('//meta').detect do |meta|
        name = (meta.attributes['name'] || meta.attributes['http-equiv']).to_s.strip
        name == 'description'
      end

      unless description_meta
        return add_issue_type(:missing_tag)
      end

      description = description_meta.attributes['content'].to_s.strip
      if description.empty?
        return add_issue_type(:missing)
      end

      if description.length <= 50
        return add_issue_type(:too_short)
      end

      if description.length > 300
        return add_issue_type(:too_long)
      end
    end
  end

  SiteHealth.register_checker(MissingDescription)
end
