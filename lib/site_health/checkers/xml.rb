module SiteHealth
  # Checks for XML-errors (backed by the excellent Nokogiri gem)
  class XML < Checker
    # @return [Array<String>] list of XML errors
    def call
      page.doc.errors.map(&:to_s)
    end

    # @return [String] the name of the checker
    def name
      "xml"
    end

    # @return [Array<Symbol>] list of page types the checker will run on
    def types
      %i[xml]
    end
  end
end
