module SiteHealth
  # Checks if HTML-meta title is present
  class PageNotFound < Checker
    def check
      # @return [Boolean] determines whether the page returned a HTTP 404 status code
      add_data(not_found: page.missing?)
    end

    # @return [String] the name of the checker
    def name
      "page_not_found"
    end

    # @return [Array<Symbol>] list of page types the checker will run on
    def types
      Checker::CHECKABLE_TYPES
    end
  end
end
