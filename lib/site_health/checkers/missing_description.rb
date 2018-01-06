module SiteHealth
  # Checks if HTML-meta description is present
  class MissingDescription < Checker
    # @return [Boolean] determines whether the description is missing
    def call
      return false if page.redirect?

      page.search("//meta").map do |meta|
        name = (meta.attributes["name"] || meta.attributes["http-equiv"]).to_s.strip
        next unless name == "description"

        return meta.attributes["content"].to_s.strip.empty?
      end

      true
    end

    # @return [String] the name of the checker
    def name
      "missing_description"
    end

    # @return [Array<Symbol>] list of page types the checker will run on
    def types
      %i[html]
    end
  end
end
