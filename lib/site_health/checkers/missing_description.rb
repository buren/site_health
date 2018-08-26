# frozen_string_literal: true

module SiteHealth
  # Checks if HTML-meta description is present
  class MissingDescription < Checker
    name 'missing_description'
    types 'html'

    def check
      # @return [Boolean] determines whether the description is missing
      return add_data(missing: false) if page.redirect?

      page.search('//meta').each do |meta|
        name = (meta.attributes['name'] || meta.attributes['http-equiv']).to_s.strip
        next unless name == 'description'

        missing = meta.attributes['content'].to_s.strip.empty?
        return add_missing_issue_and_data if missing
        return add_data(missing: false)
      end

      add_missing_issue_and_data
    end

    private

    def add_missing_issue_and_data
      add_data(missing: true)
      add_issue(title: 'missing description', severity: :medium, priority: :high)
    end
  end

  SiteHealth.register_checker(MissingDescription)
end
