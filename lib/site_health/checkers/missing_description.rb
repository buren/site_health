# frozen_string_literal: true

module SiteHealth
  # Checks if HTML-meta description is present
  class MissingDescription < Checker
    name 'missing_description'
    types 'html'
    issue_types({
      _default: {
        links: [{ href: 'https://moz.com/learn/seo/meta-description' }]
      },
      missing: { title: 'description missing' },
      too_long: { title: 'description too long' },
      too_short: { title: 'description too short' },
    })

    def check
      return if page.redirect?

      page.search('//meta').each do |meta|
        name = (meta.attributes['name'] || meta.attributes['http-equiv']).to_s.strip
        next unless name == 'description'

        description = meta.attributes['content'].to_s.strip
        if description.empty?
          return add_issue_type(:missing)
        end

        if description.length <= 50
          return add_issue_type(:too_short)
        end

        if description.length > 300
          return add_issue_type(:too_long)
        end

        return
      end

      add_issue_type(:missing)
    end
  end

  SiteHealth.register_checker(MissingDescription)
end
