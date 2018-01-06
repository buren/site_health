module SiteHealth
  # Checks if HTML-meta title is present
  class MissingTitle < Checker
    # @return [Boolean] determines whether the title is missing
    def call
      return false if page.redirect?

      page.title.to_s.strip.empty?
    end

    # @return [String] the name of the checker
    def name
      "missing_title"
    end

    # @return [Array<Symbol>] list of page types the checker will run on
    def types
      %i[html]
    end
  end
end
