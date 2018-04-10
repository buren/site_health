module SiteHealth
  # Checks if HTML-meta title is present
  class MissingTitle < Checker
    name "missing_title"
    types "html"

    def check
      # @return [Boolean] determines whether the title is missing
      return add_data(missing: false) if page.redirect?

      add_data(missing: page.title.to_s.strip.empty?)
    end
  end
end
