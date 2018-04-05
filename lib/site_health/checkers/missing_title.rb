module SiteHealth
  # Checks if HTML-meta title is present
  class MissingTitle < Checker
    def check
      # @return [Boolean] determines whether the title is missing
      return add_data(missing: false) if page.redirect?

      add_data(missing: page.title.to_s.strip.empty?)
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
